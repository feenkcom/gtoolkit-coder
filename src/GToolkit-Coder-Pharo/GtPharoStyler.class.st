Class {
	#name : #GtPharoStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Coder-Pharo-Styler'
}

{ #category : #visiting }
GtPharoStyler >> visitBooleanLiteral: aBooleanLiteral [
	self
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aBooleanLiteral value startPosition
		to: aBooleanLiteral value stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitCharacterLiteral: aCharacterLiteral [
	self
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aCharacterLiteral value startPosition
		to: aCharacterLiteral value stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitCommentFrom: aCommentStart to: aCommentEnd [
	self
		attributes: { BlTextForegroundAttribute color: Color gray darker }
		from: aCommentStart
		to: aCommentEnd
]

{ #category : #'visiting - variables' }
GtPharoStyler >> visitDeclaredGlobalVariable: aNamedVariable [
	self visitDeclaredVariable: aNamedVariable
]

{ #category : #'visiting - variables' }
GtPharoStyler >> visitDeclaredVariable: aNamedVariable [

	self
		attributes: { BlTextForegroundAttribute color: Color blue muchDarker }
		from: aNamedVariable name startPosition
		to: aNamedVariable name stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitError: anError [
	anError smaccError acceptVisitor: self
]

{ #category : #visiting }
GtPharoStyler >> visitErrorToken: anErrorToken [
	self
		attributes: { BlTextForegroundAttribute color: Color red }
		from: anErrorToken startPosition
		to: anErrorToken stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitMethodPattern: aMethodPattern [
	aMethodPattern selectorParts do: [ :eachSelectorPart |
		self visitMethodSelectorPart: eachSelectorPart ].

	super visitMethodPattern: aMethodPattern
]

{ #category : #visiting }
GtPharoStyler >> visitMethodSelectorPart: aSmaCCToken [
	self
		attributes: { BlFontWeightAttribute bold }
		from: aSmaCCToken startPosition
		to: aSmaCCToken stopPosition
]

{ #category : #'visiting - variables' }
GtPharoStyler >> visitNamedVariable: aNamedVariable [
	| isDeclaredVariable |
	
	isDeclaredVariable := aNamedVariable isUndeclared not.
	isDeclaredVariable
		ifTrue: [ ^ self visitDeclaredVariable: aNamedVariable ].
	
	isDeclaredVariable := self coderViewModel hasDeclaredVariableNamed: aNamedVariable variableName.
	isDeclaredVariable
		ifTrue: [ ^ self visitDeclaredVariable: aNamedVariable ].
	
	isDeclaredVariable := self coderViewModel hasDeclaredGlobalNamed: aNamedVariable variableName.
	isDeclaredVariable
		ifTrue: [ ^ self visitDeclaredGlobalVariable: aNamedVariable ].

	self visitUndeclaredVariable: aNamedVariable
]

{ #category : #visiting }
GtPharoStyler >> visitNilLiteral: aNilLiteral [
	self
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aNilLiteral value startPosition
		to: aNilLiteral value stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitNumberLiteral: aNumberLiteral [
	self
		attributes: { BlTextForegroundAttribute color: Color red muchDarker }
		from: aNumberLiteral value startPosition
		to: aNumberLiteral value stopPosition
]

{ #category : #visiting }
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
	self
		attributes: { BlTextForegroundAttribute color: Color green muchDarker }
		from: aSmaCCToken startPosition
		to: aSmaCCToken stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitReturn: aReturn [
	super visitReturn: aReturn.

	self visitReturnUpArrow: aReturn upArrow
]

{ #category : #visiting }
GtPharoStyler >> visitReturnUpArrow: aSmaCCToken [
	self
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aSmaCCToken startPosition
		to: aSmaCCToken stopPosition
]

{ #category : #'visiting - variables' }
GtPharoStyler >> visitSelfVariable: aSelfVariable [
	self
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aSelfVariable name startPosition
		to: aSelfVariable name stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitSmaCCError: anErrorNode [
	anErrorNode
		nodesDo: [ :eachNode | self acceptNode: eachNode ]
		andTokensDo: [ :eachToken | ]
		includeErrors: true.
	anErrorNode dismissedTokens do: [ :eachToken | self visitErrorToken: eachToken ]
]

{ #category : #visiting }
GtPharoStyler >> visitSmaCCParseNode: aSmaCCParseNode [
	super visitSmaCCParseNode: aSmaCCParseNode.

	aSmaCCParseNode comments ifNotNil: [ :theComments |
		theComments do: [ :eachComment |
			self visitCommentFrom: eachComment first to: eachComment second ] ]
]

{ #category : #visiting }
GtPharoStyler >> visitStringLiteral: aStringLiteral [
	self
		attributes: { BlTextForegroundAttribute color: Color magenta muchDarker }
		from: aStringLiteral value startPosition
		to: aStringLiteral value stopPosition
]

{ #category : #'visiting - variables' }
GtPharoStyler >> visitSuperVariable: aSuperVariable [
	self
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aSuperVariable name startPosition
		to: aSuperVariable name stopPosition
]

{ #category : #visiting }
GtPharoStyler >> visitSymbolLiteral: aSymbolLiteral [
	self
		attributes: { BlTextForegroundAttribute color: Color magenta muchDarker }
		from: aSymbolLiteral value startPosition
		to: aSymbolLiteral value stopPosition
]

{ #category : #'visiting - variables' }
GtPharoStyler >> visitThisContextVariable: aThisContextVariable [
	self
		attributes: { BlTextForegroundAttribute color: Color cyan muchDarker }
		from: aThisContextVariable name startPosition
		to: aThisContextVariable name stopPosition
]

{ #category : #'visiting - variables' }
GtPharoStyler >> visitUndeclaredVariable: aVariableNode [
	self
		attributes: { BlTextForegroundAttribute color: Color red }
		from: aVariableNode name startPosition
		to: aVariableNode name stopPosition
]
