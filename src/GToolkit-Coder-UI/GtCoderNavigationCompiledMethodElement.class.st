Class {
	#name : #GtCoderNavigationCompiledMethodElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'label',
		'compiledMethod',
		'labelElement',
		'addOnsElement',
		'addOnsCache'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'api - initialization' }
GtCoderNavigationCompiledMethodElement >> addOnsCache: anAddOnsCache [
	addOnsCache := anAddOnsCache
]

{ #category : #'api - compiled method' }
GtCoderNavigationCompiledMethodElement >> compiledMethod [
	^ compiledMethod
]

{ #category : #'api - compiled method' }
GtCoderNavigationCompiledMethodElement >> compiledMethod: aCompiledMethod [

	self assert: [ aCompiledMethod isNotNil ].
	
	compiledMethod = aCompiledMethod ifTrue: [ ^ self ].

	compiledMethod := aCompiledMethod.
	self onCompiledMethodChanged.
]

{ #category : #initialization }
GtCoderNavigationCompiledMethodElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtCoderNavigationCompiledMethodElement >> initialize [
	super initialize.

	self initializeLabelElement.
	self initializeAddonsElement.

	self addChild: labelElement.
	self addChild: addOnsElement.

	self addAptitude: BrGlamorousListItemAptitude.
	
	self
		hMatchParent;
		vFitContent
]

{ #category : #initialization }
GtCoderNavigationCompiledMethodElement >> initializeAddonsElement [
	addOnsElement := BrHorizontalPane new
			id: #addOnsContainer;
			cellSpacing: 2;
			alignCenterLeft;
			fitContent;
			withAsyncFutureDo: [ :anElementFuture | 
				anElementFuture
					executionConfiguration: GtSingleCoderViewModel secondaryMethodAddOnsExecutionConfiguration;
					whenPending: [ :theContainer | 
						theContainer removeChildren ];
					whenError: [ :theContainer :anError | 
						self updateAddOnElements: {
							anError asDebuggableElement
								hFitContentLimited;
								vFitContent } ];
					whenSuccess: [ :theContainer :someElements | 
						self updateAddOnElements: someElements ] ]
]

{ #category : #initialization }
GtCoderNavigationCompiledMethodElement >> initializeLabelElement [
	labelElement := BrLabel new.
	labelElement
		hFitContent;
		vFitContent;
		beSmallSize;
		aptitude: GtCoderNavigationTreeLabelAptitude
]

{ #category : #'api - compiled method' }
GtCoderNavigationCompiledMethodElement >> onCompiledMethodChanged [
	self updateElement
]

{ #category : #'private - updating' }
GtCoderNavigationCompiledMethodElement >> updateAddOnElements: addOnElements [
	(addOnElements allSatisfy: [ :eachElement | eachElement parent == addOnsElement ])
		ifTrue: [ ^ self ].

	addOnElements do: #removeFromParent.
	addOnsElement
		removeChildren;
		addChildren: addOnElements
]

{ #category : #'private - updating' }
GtCoderNavigationCompiledMethodElement >> updateAddonsElement [
	| aFuture |
	addOnsCache ifNil: [ ^ self ].

	GtCoderNavigationCompiledMethodsAddOnsCache isEnabled ifFalse: [ ^ self ].

	aFuture := addOnsCache elementsForCompiledMethod: compiledMethod.
	addOnsElement asyncFuture future: aFuture
]

{ #category : #'private - updating' }
GtCoderNavigationCompiledMethodElement >> updateElement [
	self updateLabelElement.
	self updateAddonsElement.
]

{ #category : #'private - updating' }
GtCoderNavigationCompiledMethodElement >> updateLabelElement [
	| aSelector |
	aSelector := compiledMethod selector asRopedText.
	compiledMethod isDeprecated ifTrue: [ aSelector lineThrough ].

	labelElement text: aSelector
]
