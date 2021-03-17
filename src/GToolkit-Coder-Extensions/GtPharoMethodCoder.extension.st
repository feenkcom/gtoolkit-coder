Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> baselineAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>

	(self behavior inheritsFrom: BaselineOf)
		ifFalse: [ ^ self ].

	coderAddOns addStyler: GtCoderExpandableBaselineStyler new
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> explanationFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>

	self explanationLink notNil
		ifTrue: [ coderAddOns addStyler: self explanationLink ].
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> gtViewAddOnFor: anAST into: coderAddOns [
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
		ifFalse: [ ^ self ].

	coderAddOns
		addContextAction: 'gtView' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self runGtViewFrom: anEvent currentTarget ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> highlighterFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	self highlighter notNil
		ifTrue: [ coderAddOns addStyler: self highlighter ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> methodExpanderFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	
	anAST methodNode
		ifNil: [ ^ self ].

	"coderAddOns addStyler: (GtCoderExpandablePharoMethodStyler new)"
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> modifiedMessageAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>

	self isModified
		ifFalse: [ ^ self ].

	coderAddOns
		addMainAction: 'Discard Changes' translated
		icon: BrGlamorousVectorIcons cancel
		action: [ :aCoderUIModel :anEvent | aCoderUIModel discardChanges ]
		id: GtMethodCoderDiscardChangesActionId
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> mondrianPaintAddOnFor: anAST into: coderAddOns [
	"<gtAstCoderAddOns: 7>"
	(self hasObjectAttribute
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | self isMondrianPaintMethod: node ]
						ifNil: [ false ] ] ])
		ifFalse: [ ^ self ].

	coderAddOns
		addContextAction: 'Mondrian' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self runMondrianPaintFrom: anEvent currentTarget ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> runGtViewFrom: anElement [
	| view |
	
	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].
	
	view := self object perform: self selector with: GtPhlowEmptyView new.
	anElement phlow spawnObject: view
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtPharoMethodCoder >> runMondrianPaintFrom: anElement [
	| mondrian |
	
	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].
	
	mondrian := GtMondrian new.
	self object perform: self selector with: mondrian.
	anElement phlow spawnObject: mondrian
]
