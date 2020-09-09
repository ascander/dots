{ pkgs }:

let
  set = "custom";

  privateBuildPlan = {
    family = "Iosevka Custom";
    design = [
      "ss08"
      "calt-center-ops"
      "calt-arrow"
      "calt-arrow2"
      "calt-eqeq"
      "calt-ineq"
      "calt-exeq"
      "calt-logic"
      "calt-colons"
      "calt-html-comment"
    ];
  };

  extraParameters =
  ''
# Rightwards arrow-like

[[iosevka.compLig]]
unicode = 57600                   # 0xE100
featureTag = 'calt'
sequence = '->'

[[iosevka.compLig]]
unicode = 57601                   # 0xE101
featureTag = 'calt'
sequence = '=>'

[[iosevka.compLig]]
unicode = 57602                   # 0xE102
featureTag = 'calt'
sequence = '->>'

[[iosevka.compLig]]
unicode = 57603                   # 0xE103
featureTag = 'calt'
sequence = '=>>'

[[iosevka.compLig]]
unicode = 57604                   # 0xE104
featureTag = 'calt'
sequence = '-->'

[[iosevka.compLig]]
unicode = 57605                   # 0xE105
featureTag = 'calt'
sequence = '==>'

[[iosevka.compLig]]
unicode = 57606                   # 0xE106
featureTag = 'calt'
sequence = '--->'

[[iosevka.compLig]]
unicode = 57607                   # 0xE107
featureTag = 'calt'
sequence = '===>'

[[iosevka.compLig]]
unicode = 57608                   # 0xE108
featureTag = 'calt'
sequence = '->-'

[[iosevka.compLig]]
unicode = 57609                   # 0xE109
featureTag = 'calt'
sequence = '=>='

# TODO fix this
[[iosevka.compLig]]
unicode = 57610                   # 0xE10A
featureTag = 'calt'
sequence = '>-'

[[iosevka.compLig]]
unicode = 57611                   # 0xE10B
featureTag = 'calt'
sequence = '>>-'

[[iosevka.compLig]]
unicode = 57612                   # 0xE10C
featureTag = 'calt'
sequence = '>>='

[[iosevka.compLig]]
unicode = 57613                   # 0xE10D
featureTag = 'calt'
sequence = '--------------------->'

# Leftwards arrow-like

[[iosevka.compLig]]
unicode = 57614                   # 0xE10E
featureTag = 'calt'
sequence = '<-'

[[iosevka.compLig]]
unicode = 57615                   # 0xE10F
featureTag = 'calt'
sequence = '<<-'

[[iosevka.compLig]]
unicode = 57616                   # 0xE110
featureTag = 'calt'
sequence = '<<='

[[iosevka.compLig]]
unicode = 57617                   # 0xE111
featureTag = 'calt'
sequence = '<--'

[[iosevka.compLig]]
unicode = 57618                   # 0xE112
featureTag = 'calt'
sequence = '<=='

[[iosevka.compLig]]
unicode = 57619                   # 0xE113
featureTag = 'calt'
sequence = '<---'

[[iosevka.compLig]]
unicode = 57620                   # 0xE114
featureTag = 'calt'
sequence = '<==='

[[iosevka.compLig]]
unicode = 57621                   # 0xE115
featureTag = 'calt'
sequence = '-<-'

[[iosevka.compLig]]
unicode = 57622                   # 0xE116
featureTag = 'calt'
sequence = '=<='

# TODO fix this
[[iosevka.compLig]]
unicode = 57623                   # 0xE117
featureTag = 'calt'
sequence = '-<'

# TODO fix this
[[iosevka.compLig]]
unicode = 57624                   # 0xE118
featureTag = 'calt'
sequence = '=<'

[[iosevka.compLig]]
unicode = 57625                   # 0xE119
featureTag = 'calt'
sequence = '-<<'

[[iosevka.compLig]]
unicode = 57626                   # 0xE11A
featureTag = 'calt'
sequence = '=<<'

# TODO fix this
[[iosevka.compLig]]
unicode = 57627                   # 0xE11B
featureTag = 'calt'
sequence = '<---------------------'

# Bidirectional arrow-like

[[iosevka.compLig]]
unicode = 57628                   # 0xE11C
featureTag = 'calt'
sequence = '<->'

[[iosevka.compLig]]
unicode = 57629                   # 0xE11D
featureTag = 'calt'
sequence = '<=>'

[[iosevka.compLig]]
unicode = 57630                   # 0xE11E
featureTag = 'calt'
sequence = '<-->'

[[iosevka.compLig]]
unicode = 57631                   # 0xE11F
featureTag = 'calt'
sequence = '<==>'

[[iosevka.compLig]]
unicode = 57632                   # 0xE120
featureTag = 'calt'
sequence = '<--->'

[[iosevka.compLig]]
unicode = 57633                   # 0xE121
featureTag = 'calt'
sequence = '<===>'

[[iosevka.compLig]]
unicode = 57634                   # 0xE122
featureTag = 'calt'
sequence = '<---->'

[[iosevka.compLig]]
unicode = 57635                   # 0xE123
featureTag = 'calt'
sequence = '<====>'

# TODO fix this
[[iosevka.compLig]]
unicode = 57636                   # 0xE124
featureTag = 'calt'
sequence = '<------------------->'

# Colons

[[iosevka.compLig]]
unicode = 57637                   # 0xE125
featureTag = 'calt'
sequence = '::'

[[iosevka.compLig]]
unicode = 57638                   # 0xE126
featureTag = 'calt'
sequence = ':::'

# Logical

[[iosevka.compLig]]
unicode = 57639                   # 0xE127
featureTag = 'calt'
sequence = '/\'

[[iosevka.compLig]]
unicode = 57640                   # 0xE128
featureTag = 'calt'
sequence = '\/'

# Comparison

[[iosevka.compLig]]
unicode = 57641                   # 0xE129
featureTag = 'calt'
sequence = '>='

[[iosevka.compLig]]
unicode = 57642                   # 0xE12A
featureTag = 'calt'
sequence = '<='

# Equality

[[iosevka.compLig]]
unicode = 57643                   # 0xE12B
featureTag = 'calt'
sequence = '=='

[[iosevka.compLig]]
unicode = 57644                   # 0xE12C
featureTag = 'calt'
sequence = '!='

[[iosevka.compLig]]
unicode = 57645                   # 0xE12D
featureTag = 'calt'
sequence = '==='

[[iosevka.compLig]]
unicode = 57646                   # 0xE12E
featureTag = 'calt'
sequence = '!=='

# Miscellaneous

# HTML comment
[[iosevka.compLig]]
unicode = 57647                   # 0xE12F
featureTag = 'calt'
sequence = '<!--'

# HTML comment (three hyphens)
[[iosevka.compLig]]
unicode = 57648                   # 0xE130
featureTag = 'calt'
sequence = '<!---'
  '';

in
  pkgs.iosevka.override {
    set = set;
    privateBuildPlan = privateBuildPlan;
    extraParameters = extraParameters;
  }
