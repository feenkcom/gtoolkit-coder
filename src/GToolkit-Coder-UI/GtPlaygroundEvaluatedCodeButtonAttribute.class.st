Class {
	#name : #GtPlaygroundEvaluatedCodeButtonAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'result',
		'action',
		'coder',
		'evaluationInterval'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Attributes'
}

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> action [
	^ action
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> action: aBlock [
	action := aBlock
]

{ #category : #initialization }
GtPlaygroundEvaluatedCodeButtonAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	<return: #BlElement>
	| aButton hoverAttribute |
	aButton := BrButton new.
	hoverAttribute := BlTextHighlightAttribute
			paint: BrGlamorousColors textHighlightColor.
	^ aButton
		aptitude: (BrLazyStyleCommonAptitude new
				default: [ :aStyle | aStyle background: BrGlamorousColors defaultButtonBorderColor ];
				hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredButtonBorderColor ])
				+ ((BrGlamorousWithTooltipAptitude
						content: [ | aContainer |
							aContainer := BlElement new
									layout: BlFrameLayout new;
									constraintsDo: [ :c | 
										c horizontal fitContent.
										c vertical fitContent ];
									when: GtPhlowObjectToSpawn
										do: [ :anEvent | 
											aButton phlow spawnPreviousEvent: anEvent ].
							self playgroundElementIn: aContainer ]) showDelay: 200 milliSeconds);
		size: 8 @ 8;
		geometry: BlEllipseGeometry new;
		margin: (BlInsets left: 2 right: 2);
		action: [ :aButtonElement :aButtonModel :anEvent | self clickEvent: anEvent from: aButtonElement ];
		when: BlMouseEnterEvent
			do: [ :anEvent | 
				evaluationInterval
					ifNotNil: [ (anEditorElement text
							from: (evaluationInterval first min: anEditorElement text size)
							to: (evaluationInterval last min: anEditorElement text size))
							attribute: hoverAttribute ] ];
		when: BlMouseLeaveEvent
			do: [ :anEvent | anEditorElement text clearAttributes: [ :each | each == hoverAttribute ] ];
		yourself
]

{ #category : #'event handling' }
GtPlaygroundEvaluatedCodeButtonAttribute >> clickEvent: anEvent from: aButton [
	self action cull: aButton cull: anEvent
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> coder [
	^ coder
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> coder: anObject [
	coder := anObject
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> evaluationInterval [
	^ evaluationInterval
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> evaluationInterval: anObject [
	evaluationInterval := anObject
]

{ #category : #initialization }
GtPlaygroundEvaluatedCodeButtonAttribute >> initialize [
	super initialize.
	self beAppend.
	action := [ :aButton :anEvent | 
		aButton phlow 
			spawnObject: self result
			withDestination: self spawnDestination ]
]

{ #category : #testing }
GtPlaygroundEvaluatedCodeButtonAttribute >> mayHaveExternalReferences [
	^ true
]

{ #category : #initialization }
GtPlaygroundEvaluatedCodeButtonAttribute >> playgroundElementIn: aContainer [
	^ (self result gtViewsFor: GtPhlowEmptyView new)
		asElementDo: [ :anInspectorElement | 
			aContainer
				addChild: ((anInspectorElement exact: 400 @ 400) asScalableElement size: 200 @ 200) ]
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> result [
	^ result
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> result: anObjectOrBlock [
	result := anObjectOrBlock
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeButtonAttribute >> spawnDestination [
	^ self coder 
		ifNil: [ GtPhlowSpawnDesiredDestination defaultDestination ]
		ifNotNil: [ self coder spawnDestination ]
]
