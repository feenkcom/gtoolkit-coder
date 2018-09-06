initialize-release
forMethod: aCompiledMethod
	| source index |
	class := aCompiledMethod methodClass.
	selector := aCompiledMethod selector.
	source := aCompiledMethod sourceCode.
	ast := GtPharoParser parse: source.
	index := self findSeparatorBetweenPatternAndBodyIn: ast.
	patternSource := source copyFrom: 1 to: index - 1.
	index := self skipBlankLinesIn: source at: index.
	bodySource := source allButFirst: index - 1