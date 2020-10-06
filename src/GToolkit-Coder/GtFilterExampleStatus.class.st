Class {
	#name : #GtFilterExampleStatus,
	#superclass : #Object,
	#traits : 'TBlDebug + TGtUniqueInstance',
	#classTraits : 'TBlDebug classTrait + TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-Filters - Support'
}

{ #category : #'api - testing' }
GtFilterExampleStatus >> includesCoder: aCoder [
	"Return true if a method filter should be displayed.
	Return false otherwise."
	^ true
]

{ #category : #'api - accessing' }
GtFilterExampleStatus >> label [
	"Return a name that is used by ${class:GtSearchExamplesFilter}$ 
	to display available example filters in ${class:GtFiltersElement}$."
	<return: #String>
	^ self className
]

{ #category : #'api - accessing' }
GtFilterExampleStatus >> labelWithAmountFor: anExampler [
	<return: #BlText>
	| aTotal aTotalString aTotalText |
	aTotal := self numberOfExamplesFor: anExampler.
	aTotalString := ' (', aTotal asString, (' example' asPluralBasedOn: aTotal), ')'.
	aTotalText := aTotalString asRopedText foreground: Color gray.
	^ self label asRopedText
		append: aTotalText.
]

{ #category : #'api - accessing' }
GtFilterExampleStatus >> labels [
	"Return all available labels"
	<return: #Array of: #String>
	^ self statuses collect: #label
]

{ #category : #'api - accessing' }
GtFilterExampleStatus >> numberOfExamplesFor: anExampler [
	"Return number of examples with a given status"
	^ 0
]

{ #category : #'api - accessing' }
GtFilterExampleStatus >> order [
	"Return a number that is used by ${class:GtSearchExamplesFilter}$ 
	to display available example filters in ${class:GtFiltersElement}$
	in a specific order (higher number, later in a list)."
	<return: #Number>
	^ 50
]

{ #category : #'api - accessing' }
GtFilterExampleStatus >> statusLabeled: aString [
	<return: #GtFilterExampleStatus>
	^ self statuses 
		detect: [ :eachStatus | eachStatus label = aString ]
		ifNone: [ GtFilterExampleAllStatus default ]
]

{ #category : #'api - accessing' }
GtFilterExampleStatus >> statuses [
	| allInstances |
	allInstances := self class allSubclasses collect: #default.
	allInstances sort: [ :a :b | a order < b order ].
	^ allInstances
]
