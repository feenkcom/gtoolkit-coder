Class {
	#name : #GtMethodCoder,
	#superclass : #Object,
	#instVars : [
		'class',
		'selector',
		'ast',
		'patternSource',
		'bodySource'
	],
	#category : 'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodCoder class >> forMethod: aCompiledMethod [
	^ self new
		forMethod: aCompiledMethod;
		yourself
]

{ #category : #converting }
GtMethodCoder >> asElement [
	| accordion styledPattern header |
	accordion := BrAccordion new.
	accordion look: BrGlamorousAccordionLook new.
	accordion margin: (BlInsets all: 5).
	accordion stencil: [ self bodyElement ].
	styledPattern := self styledPatternText.
	header := BrButton new.
	header look: BrGlamorousAccordionHeaderLook new.
	header label: styledPattern.
	header action: [ accordion toggle ].
	accordion addChildFirst: header.
	^ accordion
]

{ #category : #converting }
GtMethodCoder >> bodyElement [
	| styler completionStrategy completionController editorElement editor text |
	styler := BrRBMethodBodyTextStyler new.
	styler classOrMetaClass: class.
	styler methodPatternSource: ast pattern source.
	editor := BrTextEditor new.
	editor styler: styler.
	text := bodySource asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}.
	editor text: text.
	editorElement := BrEditorElement new.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	editorElement editor: editor.
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: class.
	completionStrategy methodPattern: ast pattern.
	completionController := GtCompletionController on: editorElement strategy: completionStrategy.
	completionController install.
	^ editorElement
]

{ #category : #accessing }
GtMethodCoder >> bodySource [
	^ bodySource
]

{ #category : #accessing }
GtMethodCoder >> bodySource: aString [
	bodySource := aString
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass [
	^ class
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass: aBehavior [
	class := aBehavior
]

{ #category : #private }
GtMethodCoder >> findSeparatorBetweenPatternAndBodyIn: aMethodNode [
	| startIndex char source |
	source := aMethodNode completeSource.
	startIndex := aMethodNode pattern stopPosition + 1.
	[ startIndex <= source size and: [ (char := source at: startIndex) isSeparator and: [ char ~= Character cr ] ] ]
		whileTrue: [ startIndex := startIndex + 1 ].
	^ startIndex
]

{ #category : #'initialize-release' }
GtMethodCoder >> forMethod: aCompiledMethod [
	| source index |
	class := aCompiledMethod methodClass.
	selector := aCompiledMethod selector.
	source := aCompiledMethod sourceCode.
	ast := GtPharoParser parse: source.
	index := self findSeparatorBetweenPatternAndBodyIn: ast.
	patternSource := source copyFrom: 1 to: index - 1.
	index := self skipBlankLinesIn: source at: index.
	bodySource := source allButFirst: index - 1
]

{ #category : #accessing }
GtMethodCoder >> patternSource [
	^ patternSource
]

{ #category : #accessing }
GtMethodCoder >> patternSource: aString [
	patternSource := aString
]

{ #category : #accessing }
GtMethodCoder >> selector [
	^ selector
]

{ #category : #accessing }
GtMethodCoder >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #private }
GtMethodCoder >> skipBlankLinesIn: source at: startIndex [
	| char index |
	index := startIndex.
	[ index <= source size and: [ (char := source at: index) = Character cr or: [ char = Character lf ] ] ]
		whileTrue: [ index := index + 1 ].
	^ index
]

{ #category : #private }
GtMethodCoder >> styledPatternText [
	| text |
	text := patternSource asRopedText.
	^ BrRBTextStyler new
		classOrMetaClass: class;
		style: text
]
