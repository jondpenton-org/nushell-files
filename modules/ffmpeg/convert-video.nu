# Converts file to extension
export def main [
  file: path
  extension: string
] {
  let output_path = (
    $file | path parse | update extension $extension | path join
  )

  try {
    ^ffmpeg -i $file -c copy -y $output_path
  } catch {
    ^ffmpeg -i $file -y $output_path
  }
}
