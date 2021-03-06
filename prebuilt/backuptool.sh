#!/sbin/sh
#
# Backup and restore proprietary Android system files
#

C=/tmp/backup
S=/system

# list in gapps-kk-20140105-signed.zip
get_files() {
cat <<EOF
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
framework/com.google.widevine.software.drm.jar
lib/libspeexwrapper.so
lib/libgames_rtmp_jni.so
lib/libRSSupport.so
lib/librs.image_wrapper.so
lib/librsjni.so
lib/librs.fixedframe.so
lib/libplus_jni_v8.so
lib/libAppDataSearch.so
lib/librs.antblur_constant.so
lib/librs.drama.so
lib/librs.film_base.so
lib/libgoogle_recognizer_jni_l.so
lib/libvcdecoder_jni.so
lib/libfrsdk.so
lib/librs.antblur_drama.so
lib/librs.retrolux.so
lib/libwebp_android.so
lib/libpatts_engine_jni_api.so
lib/libjni_unbundled_latinimegoogle.so
lib/libvideochat_jni.so
lib/libfilterpack_facedetect.so
lib/libWVphoneAPI.so
lib/librs.antblur.so
lib/librs.grey.so
etc/g.prop
etc/preferred-apps/google.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.widevine.software.drm.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/features.xml
app/MediaUploader.apk
app/GoogleContactsSyncAdapter.apk
app/GoogleEars.apk
app/GoogleTTS.apk
app/Gmail2.apk
app/GoogleCalendarSyncAdapter.apk
app/Hangouts.apk
app/GenieWidget.apk
priv-app/GoogleOneTimeInitializer.apk
priv-app/GoogleLoginService.apk
priv-app/talkback.apk
priv-app/GoogleServicesFramework.apk
priv-app/GoogleFeedback.apk
priv-app/GoogleBackupTransport.apk
priv-app/Velvet.apk app/QuickSearchBox.apk
priv-app/Phonesky.apk
priv-app/GmsCore.apk
priv-app/ConfigUpdater.apk
priv-app/GooglePartnerSetup.apk
priv-app/SetupWizard.apk app/Provision.apk
usr/srec/en-US/offensive_word_normalizer
usr/srec/en-US/wordlist
usr/srec/en-US/hotword_normalizer
usr/srec/en-US/hotword_prompt.txt
usr/srec/en-US/g2p_fst
usr/srec/en-US/hotword_word_symbols
usr/srec/en-US/hclg_shotword
usr/srec/en-US/norm_fst
usr/srec/en-US/commands.abnf
usr/srec/en-US/hotword.config
usr/srec/en-US/clg
usr/srec/en-US/grammar.config
usr/srec/en-US/endpointer_dictation.config
usr/srec/en-US/normalizer
usr/srec/en-US/hmmlist
usr/srec/en-US/ep_acoustic_model
usr/srec/en-US/dict
usr/srec/en-US/c_fst
usr/srec/en-US/compile_grammar.config
usr/srec/en-US/dnn
usr/srec/en-US/metadata
usr/srec/en-US/hmm_symbols
usr/srec/en-US/contacts.abnf
usr/srec/en-US/dictation.config
usr/srec/en-US/phonelist
usr/srec/en-US/endpointer_voicesearch.config
usr/srec/en-US/phone_state_map
usr/srec/en-US/hotword_classifier
usr/srec/en-US/rescoring_lm
EOF
}

# script entry - just copy out and copy in
case "$1" in
    backup)
        mount $S

        # Do not backup incompatible version of gapps
        if [ x`sed -ne "/^ro.build.version.release=4.4.*$/p" /system/build.prop` == x'' ]
        then
            echo "imcompatible version of gapps!"
            umount $S
            exit 0
        fi

        rm -rf $C
        mkdir -p $C
        get_files | while read file
        do
            if [ -e $S/$file ]
            then
                echo "backup: $file"
                fname=`echo $file | busybox sed 's!/!_!g'`
                cp -p $S/$file $C/$fname
            fi
        done
        umount $S
        ;;
    restore)
        get_files | while read file
        do
            fname=`echo $file | busybox sed 's!/!_!g'`
            if [ -e $C/$fname ]
            then
                echo "restore: $file"
                cp -p $C/$fname $S/$file
            fi
        done
        rm -rf $C
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
esac

exit 0
