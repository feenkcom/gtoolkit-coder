Class {
	#name : #GtMethodCoder,
	#superclass : #Object,
	#instVars : [
		'class',
		'selector',
		'ast',
		'patternSource',
		'originalBodySource',
		'textEditor',
		'category'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodCoder class >> forMethod: aCompiledMethod [
	^ self new
		forMethod: aCompiledMethod;
		yourself
]

{ #category : #elements }
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
	header addChild: self categoryElement.
	header addChild: self instClassElement.
	header addChild: self saveElement.
	accordion addChildFirst: header.
	^ accordion
]

{ #category : #elements }
GtMethodCoder >> bodyElement [
	| styler completionStrategy completionController editorElement text |
	styler := BrRBMethodBodyTextStyler new.
	styler classOrMetaClass: class.
	styler methodPatternSource: ast pattern source.
	textEditor styler: styler.
	textEditor
		when: BrTextEditorInsertedEvent do: [ :event | self clearSyntaxErrors ];
		when: BrTextEditorDeletedEvent do: [ :event | self clearSyntaxErrors ].
	text := originalBodySource asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}.
	textEditor text: text.
	editorElement := BrEditorElement new.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	editorElement editor: textEditor.
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: class.
	completionStrategy methodPattern: ast pattern.
	completionController := GtCompletionController on: editorElement strategy: completionStrategy.
	completionController install.
	^ editorElement
]

{ #category : #accessing }
GtMethodCoder >> bodySource [
	^ textEditor text asString
]

{ #category : #elements }
GtMethodCoder >> categoryElement [
	| element |
	element := self dropDownElementWithItems: class organization categories asSortedCollection label: category.
	element
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c
				margin:
					(BlInsets
						top: 0
						left: 0
						bottom: 0
						right: 55).
			c ignored horizontal alignRight.
			c ignored vertical alignCenter ].
	^ element
]

{ #category : #actions }
GtMethodCoder >> changeFactory [
	^ RBRefactoryChangeFactory new
]

{ #category : #actions }
GtMethodCoder >> changeManager [
	^ RBRefactoryChangeManager instance
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
GtMethodCoder >> clearSyntaxErrors [
	textEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #elements }
GtMethodCoder >> dropDownElementWithItems: aCollection label: aString [
	| element arrow size arrowHeight arrowWidth listElement overlay index |
	overlay := self newPopupElement.
	listElement := self dropDownList: aCollection.
	index := aCollection indexOf: aString.
	index > 0
		ifTrue: [ listElement selectOne: index.
			listElement children first scrollToPosition: index ].
	listElement
		when: BlFocusOutEvent
		do: [ :event | 
			overlay isAttachedToSceneGraph
				ifTrue: [ overlay
						detach;
						removeFromParent ] ].
	overlay addChild: listElement.
	size := 100 @ 20.
	arrowHeight := size y - 10.
	arrowWidth := (arrowHeight * 2 sqrt) rounded.
	(arrow := BlElement new)
		size: arrowWidth @ arrowHeight;
		geometry:
			(BlPolygon
				vertices:
					{(0 @ 0).
					(arrowWidth @ 0).
					((arrowWidth / 2) rounded @ arrowHeight)});
		background: (Color veryLightGray alpha: 0.5);
		relocate: (size x - arrowWidth + 5) @ ((size y - arrowHeight) / 2 + 1) rounded;
		yourself.
	(element := BlTextElement new)
		text: (aString ifNil: [ '' ]) asRopedText;
		size: size;
		border: (BlBorder paint: Color veryLightGray width: 2);
		padding:
			(BlInsets
				top: 4
				left: 10
				bottom: 0
				right: 6);
		background: Color white;
		geometry: (BlRectangle cornerRadius: 12);
		when: BlClickEvent
			do: [ :event | 
			overlay isAttachedToSceneGraph
				ifTrue: [ overlay
						detach;
						removeFromParent ]
				ifFalse: [ element space root addChild: overlay.
					listElement requestFocus ].
			event consumed: true ];
		when: BlMouseOutEvent do: [ :event | element background: Color white ];
		when: BlMouseOverEvent do: [ :event | element background: Color veryLightGray ];
		addChild: arrow.
	overlay attachTo: element.
	^ element
]

{ #category : #elements }
GtMethodCoder >> dropDownList: items [
	^ BrSimpleList new
		lookDo: [ :aLook | 
			aLook listElement
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal matchParent.
					c maxHeight: 200 ] ];
		background: Color white;
		border: (BlBorder paint: Color lightGray width: 1);
		padding: (BlInsets all: 2);
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ];
		display: items;
		stencil: [ :each :anIndex | 
			BlTextElement new
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				text: (each displayString asRopedText thin monospace fontSize: 12) ]
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
	category := class whichCategoryIncludesSelector: selector.
	source := aCompiledMethod sourceCode.
	ast := GtPharoParser parse: source.
	index := self findSeparatorBetweenPatternAndBodyIn: ast.
	patternSource := source copyFrom: 1 to: index - 1.
	index := self skipBlankLinesIn: source at: index.
	originalBodySource := source allButFirst: index - 1.
	textEditor := BrTextEditor new.
	textEditor text: originalBodySource asRopedText
]

{ #category : #elements }
GtMethodCoder >> instClassElement [
	| element |
	element := self
		dropDownElementWithItems: #('instance' 'class')
		label:
			(self classOrMetaClass isMeta
				ifTrue: [ 'class' ]
				ifFalse: [ 'instance' ]).
	element
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c
				margin:
					(BlInsets
						top: 0
						left: 0
						bottom: 0
						right: 181).
			c ignored horizontal alignRight.
			c ignored vertical alignCenter ].
	^ element
]

{ #category : #actions }
GtMethodCoder >> methodSource [
	^ patternSource , String cr , self bodySource
]

{ #category : #elements }
GtMethodCoder >> newPopupElement [
	^ GtDropDownPopupElement new
		layout: BlLinearLayout vertical;
		background: Color red;
		constraintsDo: [ :c |
			c vertical fitContent.
			c horizontal exact: 100 ]
]

{ #category : #accessing }
GtMethodCoder >> patternSource [
	^ patternSource
]

{ #category : #accessing }
GtMethodCoder >> patternSource: aString [
	patternSource := aString
]

{ #category : #actions }
GtMethodCoder >> requester [
	^ GtMethodCoderRequester on: self
]

{ #category : #actions }
GtMethodCoder >> save [
	originalBodySource = self bodySource
		ifTrue: [ ^ self ].
	self changeManager
		performChange:
			(self changeFactory
				addMethodSource: self methodSource
				in: class
				classified: category
				for: self requester)
]

{ #category : #elements }
GtMethodCoder >> saveElement [
	| button |
	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons save asElement;
		action: [ self save ];
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c
				margin:
					(BlInsets
						top: 0
						left: 0
						bottom: 0
						right: 10).
			c ignored horizontal alignRight.
			c ignored vertical alignCenter ].
	^ button
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

{ #category : #private }
GtMethodCoder >> textEditor [
	^ textEditor
]
