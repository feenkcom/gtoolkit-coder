Extension { #name : #GtMethodCoder }

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> baselineAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(anAST isNil or: [ anAST methodNode isNil ])
		ifTrue: [ coderAddOns removeStylerOfType: GtCoderExpandableMethodStyler.
			^ self ].
	(self behavior isNil or: [ (self behavior inheritsFrom: BaselineOf) not ])
		ifTrue: [ ^ self ].
	coderAddOns addStyler: GtCoderExpandableBaselineStyler new
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> exampleAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self compiledMethod notNil
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | 
							node pragmas
								anySatisfy: [ :each | each isParseError not and: [ each selector = #gtExample ] ] ]
						ifNil: [ false ] ] ])
		ifFalse: [ coderAddOns removeStylerOfType: GtCoderExampleStatusStyler.
			coderAddOns
				removeContextAction: 'Play and Inspect Example Result' translated.
			coderAddOns
				removeContextAction: 'Inspect Example Object' translated.
			^ self ].
	coderAddOns
		addStyler:
			(GtCoderExampleStatusStyler new
				coder: self;
				classOrMetaClass: self behavior).
	(self canExecuteExample or: [ anAST methodNode numArgs isZero ])
		ifFalse: [ ^ self ].
	coderAddOns
		addContextAction: 'Play' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anEvent | self playExample ].
	coderAddOns
		addContextAction: 'Play and Inspect Example Result' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self playAndInspectExample ].
	coderAddOns
		addContextAction: 'Inspect Example Object' translated
		icon: BrGlamorousVectorIcons eg
		action: [ :aCoderUIModel :anEvent | self notifyObjectSpawn: self example ].
	coderAddOns
		addContextAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anEvent | self debugExample ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> explanationFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	coderAddOns removeStylerOfType: GtSourceExplanationLinkStyler.
	self explanationLink notNil
		ifTrue: [ coderAddOns addStyler: self explanationLink ].
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> gtViewAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 6>
	(self hasObjectAttribute
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | 
							node arguments size = 1
								and: [ node pragmas
										anySatisfy:
											[ :each | each isParseError not and: [ each selector = #gtView ] ] ] ]
						ifNil: [ false ] ] ])
		ifFalse: [ coderAddOns removeContextAction: 'gtView' translated.
			^ self ].
	coderAddOns
		addContextAction: 'gtView' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self runGtViewFrom: anEvent currentTarget ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> highlighterFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	coderAddOns removeStylerOfType: GtSourceReferenceHighlighter.
	self highlighter notNil
		ifTrue: [ coderAddOns addStyler: self highlighter ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> methodExpanderFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(anAST isNil or: [ anAST methodNode isNil ])
		ifTrue: [ coderAddOns removeStylerOfType: GtCoderExpandableMethodStyler.
			^ self ].
	coderAddOns addStyler: GtCoderExpandableMethodStyler new
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> modifiedMessageAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>
	self isModified
		ifTrue: [
			coderAddOns
				addMainAction: 'Discard Changes' translated
				icon: BrGlamorousVectorIcons cancel
				action: [ :aCoderUIModel :anEvent | self discardChanges ] ]
		ifFalse: [ coderAddOns removeMainAction: 'Discard Changes' translated ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> mondrianPaintAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 7>
	(self hasObjectAttribute
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | self isMondrianPaintMethod: node ]
						ifNil: [ false ] ] ])
		ifFalse: [ coderAddOns removeContextAction: 'Mondrian' translated.
			^ self ].
	coderAddOns
		addContextAction: 'Mondrian' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self runMondrianPaintFrom: anEvent currentTarget ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> runGtViewFrom: anElement [
	| view |
	
	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].
	
	view := self object perform: self selector with: GtPhlowEmptyView new.
	anElement phlow spawnObject: view
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtMethodCoder >> runMondrianPaintFrom: anElement [
	| mondrian |
	
	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].
	
	mondrian := GtMondrian new.
	self object perform: self selector with: mondrian.
	anElement phlow spawnObject: mondrian
]
