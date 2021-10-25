Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowse [
	^ (GtCoder forClass: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowseFrom: anElement [
	^ ((GtCoder forClass: self) 
		openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
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
				stencil: [ methodsCoder asElement ];
				actionButtonIcon: BrGlamorousIcons browse 
					tooltip: 'Browse ', aClass name 
					action: [ :aButton | 
						aButton phlow spawnTool: (GtClassCoderTool forClass: aClass) ] ]
		ifAbsent: [ aView empty ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> methodsCoderFromContext: aPhlowContext [
	<return: #GtPharoMethodsCoderViewModel>

	^ aPhlowContext
		optionAt: #behaviorCoder
		ifPresent: [ :aBehaviorCoderUIModel | aBehaviorCoderUIModel methodsCoderUIModel ]
		ifAbsentPut: [ (GtClassMethodsCoder forClass: self) asCoderUIModel ]
]
