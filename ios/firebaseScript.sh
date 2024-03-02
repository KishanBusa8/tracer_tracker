if [ "$CONFIGURATION" == "Debug-tracer" ] || [ "$CONFIGURATION" == "Release-tracer" ]; then
  cp Runner/tracer/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-tracker" ] || [ "$CONFIGURATION" == "Release-tracker" ]; then
  cp Runner/tracker/GoogleService-Info.plist Runner/GoogleService-Info.plist
fi

