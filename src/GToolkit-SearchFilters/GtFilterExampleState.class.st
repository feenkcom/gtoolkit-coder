Class {
	#name : #GtFilterExampleState,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-SearchFilters-Support'
}

{ #category : #'api - accessing' }
GtFilterExampleState >> allLabels [
	"Return all available labels"
	<return: #Array of: #String>
	^ self allStates collect: #label
]

{ #category : #'api - accessing' }
GtFilterExampleState >> allStates [
	| allInstances |
	allInstances := self class allSubclasses collect: #default.
	allInstances sort: [ :a :b | a order < b order ].
	^ allInstances
]

{ #category : #'api - accessing' }
GtFilterExampleState >> color [
	"Return a color that represents given state"
	<return: #Color>
	^ Color transparent
]

{ #category : #'api - testing' }
GtFilterExampleState >> includesCoder: aCoder [
	"Return true if a method filter should be displayed.
	Return false otherwise."
	^ true
]

{ #category : #'api - testing' }
GtFilterExampleState >> isStatusFor: aGtExampleWithResult [
	"Return true if the status is equal to the example result status"
	<return: #Boolean>
	^ self subclassResponsibility
]

{ #category : #'api - accessing' }
GtFilterExampleState >> label [
	"Return a name that is used by ${class:GtSearchExamplesFilter}$ 
	to display available example filters in ${class:GtFiltersElement}$."
	<return: #String>
	^ self className
]

{ #category : #'api - accessing' }
GtFilterExampleState >> labelWithAmountFor: anExampler [
	<return: #BlText>
	| aTotal aTotalString aTotalText |
	aTotal := self numberOfExamplesFor: anExampler.
	aTotalString := ' (', aTotal asString, (' example' asPluralBasedOn: aTotal), ')'.
	aTotalText := aTotalString asRopedText foreground: Color gray.
	^ self label asRopedText
		append: aTotalText.
]

{ #category : #'api - accessing' }
GtFilterExampleState >> numberOfExamplesFor: anExampler [
	"Return number of examples with a given state"
	^ 0
]

{ #category : #'api - accessing' }
GtFilterExampleState >> order [
	"Return a number that is used by ${class:GtSearchExamplesFilter}$ 
	to display available example filters in ${class:GtFiltersElement}$
	in a specific order (higher number, later in a list)."
	<return: #Number>
	^ 50
]

{ #category : #'api - accessing' }
GtFilterExampleState >> stateFromExample: aGtExampleWithResult [
	aGtExampleWithResult ifNotNil: [ 
		self allStates do: [ :eachStatus | 
			(eachStatus isStatusFor: aGtExampleWithResult)
				ifTrue: [ ^ eachStatus ] ] ].
	^ GtFilterExampleNotExecutedState default
]

{ #category : #'api - accessing' }
GtFilterExampleState >> stateFromLabel: aLabel [
	<return: #GtFilterExampleState>
	| aString |
	aString := aLabel asString.
	^ self allStates 
		detect: [ :eachStatus | eachStatus label = aString ]
		ifNone: [ GtFilterExampleAllState default ]
]
