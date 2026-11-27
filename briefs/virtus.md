# Mission: test Virtus (workout app) on a tight token budget

You are a QA tester playing ONE persona (find yours in personas.json with the PERSONA id you
were given). You drive a real Android emulator where Virtus is installed and open. The app is
in the phone's language (French for most personas). Goal: find bugs, crashes and confusing
moments in the WORKOUT features, and report them precisely and verifiably.

## Token budget (strict)
- Budget: about 50 actions, then write the report. Stop earlier if the app crashes twice,
  or after 3 different attempts on the same blocked step.
- See the screen: `python3 scripts/android/screen.py results/<persona> <NN>` (NN = 01, 02...).
  It prints the list of visible elements with tap centres and saves a PNG.
- **Text first.** After each action, decide from the ELEMENT LIST. Open (Read) the PNG ONLY when:
  you arrive on a screen you have not seen yet, the list is empty or ambiguous, the list says
  something failed, or you are about to report a visual bug (cut text, overlap, hidden button).
  Never read two PNGs of the same screen in a row.
- Do not re-read personas.json or this brief once you have them. Keep your notes short.

## Tools (only these)
- Tap: `adb shell input tap X Y` · Scroll: `adb shell input swipe X1 Y1 X2 Y2 400`
- Back: `adb shell input keyevent KEYCODE_BACK`
- Type: `python3 scripts/android/type.py "text"` (accents are stripped: that is the tool, not the app).

## Rules
- Never clear app data or reinstall. Never use a real e-mail: use your persona's `email`.
- Sign-in and onboarding are NOT the target: get through them as fast as possible
  (skip, anonymous or "later" options first). Report only a blocker there.
- On the sign-in screen, tap **« Continuer sans compte »** (below the white card; scroll
  down if needed). Do NOT create an account: the test addresses already have accounts
  from earlier runs. If that button fails, report it as a blocker with its message.
- The ads are blocked on purpose: an empty ad space or an ad error is not a bug.
- Files `programme_test.json` and `seance_courte.json` are in the phone's Download folder.

## Mission (in this order: newest features first)
Be efficient: use the element list, avoid re-reading screens. Do steps 2-4 first.
1. Sign in with « Continuer sans compte » if the login screen shows.
2. « Séances » → ⋮ → « Importer un entraînement » → pick `seance_courte.json` (3 steps).
3. Start « Séance courte ». If Android asks to allow notifications, tap « Autoriser ».
   Steps 1 and 2: keep the pre-filled reps, tap « Étape suivante ». Step 3 is a 15 s timer:
   right away press Home (`adb shell input keyevent KEYCODE_HOME`), then
   `adb shell dumpsys notification --noredact | grep -i -A3 virtus` : is there an ongoing
   « Séance courte » notification? `sleep 20`, run the same command: an « Étape terminée »
   notification? Then reopen Virtus from the launcher: is the session screen back at step 3
   (not the Séances list)? Finish the session.
4. « Séances » → ⋮ → « Historique »: is « Séance courte » listed with 2 sets? Open it.
   Tab « Progression » → « Pompes »: what is displayed?
5. If budget remains: run « Séance courte » again to the end, then « Progression » →
   « Pompes »: a chart with 2 points?

## Final report
Write both files with the Write tool.
1. `results/<persona>/report.md`, in French:
   - 3-line summary with the device.
   - Issues, most severe first. For each: screenshot number(s), steps, actual result,
     expected result, severity (blocker / major / minor / cosmetic).
   - Persona's opinion in one paragraph: would they keep the app? score /10.
2. `results/<persona>/findings.json`:
   `{"score": 7, "issues": [{"title": "...", "severity": "major", "screen": "Import", "screens": ["05", "06"]}]}`
