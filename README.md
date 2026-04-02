# Batch Annotation Script

## Usage

1. Run the script in Praat
2. Select your **input folder** (sound files)
3. Select your **output folder** (for TextGrids)
4. Set your tier names and types, click OK
5. Annotate → Click **Next** → Repeat

## Settings

| Field | Example | Notes |
|-------|---------|-------|
| Tier names | `words,phonemes` | Comma-separated |
| Tier types | `interval,interval` | Use `interval` or `point` |

## Controls

- **Next**: Save current file, open next one
- **Stop**: Save current file, exit script

## Notes

- Files are sorted alphabetically
- If a TextGrid already exists, it loads that instead of creating new
- Progress shows in the dialog title: `File 5/100: filename`
