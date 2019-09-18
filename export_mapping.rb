require 'pathname'
require 'bin_utils'


def export(directory, cells_per_row)
    files = ["cem-3", "cem-2", "cem-1", "cem0", "cem1", "cem2", "cem3"]
    parent = Pathname(directory)

    files.each  { |file|
        export_one(parent + file, cells_per_row)
    }

end

def export_one(file, cells_per_row)
    # 各データファイルには，4バイトビッグエンディアンの羅列が格納されている．
    length_row = 4 * cells_per_row
    csv_file = "#{file.to_s}.csv"
    File.open(file, "rb", :encoding => "ASCII-8BIT") { |source| 
    File.open(csv_file, "w") { |destination|
        until (source.eof?)

            row = source.read(length_row)
            # 4字ごとに分割
            row_data = (0...cells_per_row).map { |i|
                BinUtils.get_int32_be(row[i * 4, 4])
            }
            destination.puts(row_data.join(","))
        end
    }
    }
end

export(ARGV[0], Integer(ARGV[1]))
