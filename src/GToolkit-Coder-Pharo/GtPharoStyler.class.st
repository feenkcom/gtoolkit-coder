Class {
	#name : #GtPharoStyler,
	#superclass : #GtCoderAstStyler,
	#traits : 'TGtPharoProgramNodeVisitor',
	#classTraits : 'TGtPharoProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-Pharo-Styler'
}

{ #category : #'api - styling' }
GtPharoStyler >> style: aText ast: theAst [
	text := aText.
	[ self accept: theAst ]
		ensure: [ text := nil ]
]

{ #category : #generated }
GtPharoStyler >> visitAssignment: anAssignment [
	self accept: anAssignment variable.
	self accept: anAssignment value
]

{ #category : #generated }
GtPharoStyler >> visitBooleanLiteral: aBooleanLiteral [
	text
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aBooleanLiteral value startPosition
		to: aBooleanLiteral value stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitCharacterLiteral: aCharacterLiteral [
	text
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aCharacterLiteral value startPosition
		to: aCharacterLiteral value stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitCommentFrom: aCommentStart to: aCommentEnd [
	text
		attributes: { BlTextForegroundAttribute color: Color gray darker }
		from: aCommentStart
		to: aCommentEnd
]

{ #category : #generated }
GtPharoStyler >> visitError: anError [
	anError smaccError
		nodesDo: [ :eachNode | self acceptNode: eachNode ]
		andTokensDo: [ :eachToken | ]
		includeErrors: true.

	anError smaccError dismissedTokens do: [ :eachToken | self visitErrorToken: eachToken ]
]

{ #category : #visiting }
GtPharoStyler >> visitErrorToken: anErrorToken [
	text
		attributes: { BlTextForegroundAttribute color: Color red }
		from: anErrorToken startPosition
		to: anErrorToken stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitMethod: aMethod [
	aMethod comments ifNotNil: [ :theComments |
		theComments do: [ :eachComment |
			self visitCommentFrom: eachComment first to: eachComment second ] ].
	
	^ self visitProgram: aMethod
]

{ #category : #generated }
GtPharoStyler >> visitMethodPattern: aMethodPattern [
	aMethodPattern selectorParts do: [ :eachSelectorPart |
		self visitMethodSelectorPart: eachSelectorPart ].

	^ self visitProgram: aMethodPattern
]

{ #category : #generated }
GtPharoStyler >> visitMethodSelectorPart: aSmaCCToken [
	text
		attributes: { BlFontWeightAttribute bold }
		from: aSmaCCToken startPosition
		to: aSmaCCToken stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitNamedVariable: aNamedVariable [
	text
		attributes: { BlTextForegroundAttribute color: Color blue muchDarker }
		from: aNamedVariable name startPosition
		to: aNamedVariable name stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitNilLiteral: aNilLiteral [
	text
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aNilLiteral value startPosition
		to: aNilLiteral value stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitNumberLiteral: aNumberLiteral [
	text
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aNumberLiteral value startPosition
		to: aNumberLiteral value stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitPragma: aPragma [
	
	self visitPragmaSelectorPart: aPragma lessThan.
	aPragma selectorParts do: [ :eachSelectorPart |
		self visitPragmaSelectorPart: eachSelectorPart ].
	self visitPragmaSelectorPart: aPragma greaterThan.
	
	aPragma values do: [ :eachPragmaValue |
		self acceptNode: eachPragmaValue ]
]

{ #category : #visiting }
GtPharoStyler >> visitPragmaSelectorPart: aSmaCCToken [
	text
		attributes: { BlTextForegroundAttribute color: Color green muchDarker }
		from: aSmaCCToken startPosition
		to: aSmaCCToken stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitReturn: aReturn [
	self visitReturnUpArrow: aReturn upArrow.
	
	^ self visitProgram: aReturn
]

{ #category : #visiting }
GtPharoStyler >> visitReturnUpArrow: aSmaCCToken [
	text
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aSmaCCToken startPosition
		to: aSmaCCToken stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitSelfVariable: aSelfVariable [
	text
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aSelfVariable name startPosition
		to: aSelfVariable name stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitStringLiteral: aStringLiteral [
	text
		attributes: { BlTextForegroundAttribute color: Color magenta muchDarker }
		from: aStringLiteral value startPosition
		to: aStringLiteral value stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitSuperVariable: aSuperVariable [
	text
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aSuperVariable name startPosition
		to: aSuperVariable name stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitSymbolLiteral: aSymbolLiteral [
	text
		attributes: { BlTextForegroundAttribute color: Color magenta muchDarker }
		from: aSymbolLiteral value startPosition
		to: aSymbolLiteral value stopPosition
]

{ #category : #generated }
GtPharoStyler >> visitThisContextVariable: aThisContextVariable [
	text
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aThisContextVariable name startPosition
		to: aThisContextVariable name stopPosition
]
