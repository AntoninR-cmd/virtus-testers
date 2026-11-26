# Mission: test Virtus (workout app) on a tight token budget

You are a QA tester playing ONE persona (find yours in personas.json with the PERSONA id you
were given). You drive a real Android emulator where Virtus is installed and open. The app is
in the phone's language (French for most personas). Goal: find bugs, crashes and confusing
moments in the WORKOUT features, and report them precisely and verifiably.

## Token budget (strict)
- Budget: about 35 actions, then write the report. Stop earlier if the app crashes twice,
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
- A file `programme_test.json` is in the phone's Download folder.

## Mission (in this order: newest features first)
1. Sign in with « Continuer sans compte ». Glance at the home tab: is it clear what to do?
2. Exercise library. Bottom bar « Séances » → open any plan in the editor → edit one step →
   tap the dumbbell icon next to the title. Search « pompes »: are results relevant? Try one
   equipment filter chip. Tap a result: the sheet shows muscles, a « Voir une vidéo » button
   (do NOT tap it) and a source/licence line. Tap « Choisir cet exercice »: the step title
   changes and a « Lié : … » chip appears. Save the step and the plan.
3. Custom exercise. Edit another step → dumbbell icon → search a made-up word like « zorblax »:
   is « Créer un exercice » offered? Create it (name only is enough), save: is it linked?
4. Session tracking. Start a session on that plan. On the step linked to an exercise, are there
   reps / weight inputs? Enter a value, go to the next step, then one more.
5. Resume. Force-stop the app (`adb shell am force-stop <package>`), launch it again from the
   launcher (never clear data), open « Séances »: is a « Séance en cours » card shown? Tap
   « Reprendre »: does it continue at the right step? Then leave the session.
6. Account page (top-right icon on the home tab) → « Crédits et licences »: readable? Back.
7. « Séances » → ⋮ → « Générer avec une IA »: is the page clear? Copy the prompt, go back.
8. ⋮ → paste import: tap « Insérer un exemple », import it. Is the summary clear?
   Then paste an invalid JSON `{"plans":[{}]}` and import: is the error message clear?
9. Count your plans: any duplicates or missing ones after the restart of step 5?

## Final report
Write both files with the Write tool.
1. `results/<persona>/report.md`, in French:
   - 3-line summary with the device.
   - Issues, most severe first. For each: screenshot number(s), steps, actual result,
     expected result, severity (blocker / major / minor / cosmetic).
   - Persona's opinion in one paragraph: would they keep the app? score /10.
2. `results/<persona>/findings.json`:
   `{"score": 7, "issues": [{"title": "...", "severity": "major", "screen": "Import", "screens": ["05", "06"]}]}`
