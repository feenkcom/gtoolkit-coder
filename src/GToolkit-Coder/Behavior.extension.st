Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowse [
	^ (GtCoder forClass: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFrom: anElement [
	^ ((GtCoder forClass: self) 
		openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderCommentsFor: aView [
	<gtClassView>

	^ aView explicit
		title: 'Comment';
		tooltip: 'Class comment';
		priority: 30;
		actionUpdateButtonTooltip: 'Update class comment';
		stencil: [ (GtDocument forClass: self) asElement ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderExamplesFor: aView context: aDictionary [
	<gtClassView>
	| anExamplesClassName |

	anExamplesClassName := (self name , 'Examples') asSymbol.

	^ self environment
		at: anExamplesClassName
		ifPresent: [ :aClass | 
			| methodsCoder |
			methodsCoder := GtClassMethodsCoder forClass: aClass.
			aView explicit
				priority: 50;
				title: 'Related examples';
				actionButtonIcon: BrGlamorousVectorIcons add
					action: [ methodsCoder addNewCoder ];
				stencil: [ methodsCoder asElement ] ]
		ifAbsent: [ aView empty ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderMethodsFor: aView context: aDictionary [
	<gtClassView>
	| methodsCoder object |

	aDictionary
		at: #classCoder
		ifPresent: [ :coder | object := coder object ].

	methodsCoder := object notNil
		ifTrue: [ GtClassMethodsCoder forObject: object ]
		ifFalse: [ GtClassMethodsCoder forClass: self ].

	^ aView explicit
		priority: 10;
		title: 'Methods';
		disableAsync;
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add new method'
			action: [ methodsCoder addNewCoder ];
		stencil: [ methodsCoder asElement ]
]
