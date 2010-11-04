function process_symbol_class(symbol_class) {
    var len = symbol_class.length;

    if (len == 1) return [symbol_class];
    else if (len == 2) return [];
    else if (symbol_class[0] != '[' || symbol_class[len-1] != ']') return [];

    var result = [];
    for (var i = 1; i < len - 1; i++) {
        if (symbol_class[i+1] == '-' && i < len - 3) {
            var c  = symbol_class.charCodeAt(i);
            var ec = symbol_class.charCodeAt(i+2);
            while (c <= ec) {
                result.push(String.fromCharCode(c));
                c++;
            }

            i += 2;
        }
        else result.push(symbol_class[i]);
    }
    return result;
}

function process() {
    var src = document.getElementById("source").value;
    var lines = src.split("\n");

    var result = [];
    var line_re = /^(\s*)([^ ]+)\s+([^ ]+)\s+->\s+([^ ]+)\s+([^ ]+)\s+([^ ]+)\s*$/;
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        var match = line_re.exec(line);
        if (match) {
            var symbols = process_symbol_class(match[2]);

            if (!symbols) {
                result.push(line);
                continue;
            }

            for (var j = 0; j < symbols.length; j++) {
                var new_symbol = match[4];
                if (new_symbol == "$$") new_symbol = symbols[j];

                result.push(
                    match[1] + symbols[j] + " " + match[3] +
                    " -> " + new_symbol + " " + match[5] + " " + match[6]
                );
            }
        }
        else result.push(line);
    }

    document.getElementById("result").value = result.join("\n");
}

