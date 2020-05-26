Class {
	#name : #GtBehaviorMethodCoderCategoryLook,
	#superclass : #GtMethodCoderCategoryLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> addMethodTags [
	| tags |
	self widget
		childNamed: #header
		ifFound: [ :header | header visibility: BlVisibility gone ]
		ifNone: [  ].
	tags := BrHorizontalPane new.
	tags fitContent.
	tags cellSpacing: 2.
	tags
		addChild: self buildCategoryEditor as: self categoryEditorName;
		addChild: self buildClassTag as: self classTagName.
	self attachToBottomRight: tags.
	self widget addChild: tags as: self tagsName
]

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> buildClassTag [
	| editor completion strategy |
	editor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				glamorousCodeFont;
				defaultForeground: Color black;
				fontSize: 10);
		padding: (BlInsets all: 2);
		margin: (BlInsets all: 0);
		text: self classTagText;
		when: BrEditorModeWish
			do: [ :wish | 
			(wish mode isEditable
				and: [ self methodCoder canMoveMethodToInstanceOrClass not ])
				ifTrue: [ editor beReadOnlyWithoutSelection.
					wish mode: BrTextEditorReadonlyWithoutSelectionMode new ] ];
		when: BrEditorAcceptWish
			do: [ :wish | 
			(self methodCoder classOrMetaClass isMeta
				ifTrue: [ wish text asString asLowercase = 'instance' ]
				ifFalse: [ wish text asString asLowercase = 'class' ])
				ifTrue: [ self methodCoder moveMethodToInstanceOrClass ].
			editor text: self classTagText.
			wish consumed: true ].
	strategy := GtStringsCompletionStrategy new.
	(GtCompletionController on: editor strategy: strategy) install.
	completion := GtPrefixTree withAll: #('instance' 'class').
	strategy completions: completion.
	^ editor
]

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> classTagName [
	^ #classTag
]

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> classTagText [
	^ (self methodCoder classOrMetaClass isMeta
		ifTrue: [ 'class' ]
		ifFalse: [ 'instance' ]) asRopedText glamorousCodeFont fontSize: 10
]

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> removeMethodTags [
	self widget
		childNamed: self tagsName
		ifFound: [ :tags | tags removeFromParent ]
		ifNone: [  ].
	self widget
		childNamed: #header
		ifFound: [ :header | header visibility: BlVisibility visible ]
		ifNone: [  ]
]

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> tagsName [
	^ #tags
]
