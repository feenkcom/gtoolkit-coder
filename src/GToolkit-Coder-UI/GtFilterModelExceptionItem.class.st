"
I am displayed if there is an exception while computing model items.
For intenal use only. I must not be used as an expected model item.
"
Class {
	#name : #GtFilterModelExceptionItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'exception'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'instance creation' }
GtFilterModelExceptionItem class >> freeze: anException [
	^ self new exception: (GtSystemUtility freeze: anException)
]

{ #category : #accessing }
GtFilterModelExceptionItem >> exception [
	^ exception
]

{ #category : #accessing }
GtFilterModelExceptionItem >> exception: anObject [
	exception := anObject
]

{ #category : #'gt - extensions' }
GtFilterModelExceptionItem >> gtExceptionMessageFor: aView [
	<gtView>
	exception ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Exception message';
		object: [ exception ];
		view: #gtMessageTextFor:
]

{ #category : #'gt - extensions' }
GtFilterModelExceptionItem >> gtExceptionStackFor: aView [
	<gtView>
	exception ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Exception stack';
		object: [ exception ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtFilterModelExceptionItem >> icon [
	^ BrGlamorousVectorIcons debug
]

{ #category : #accessing }
GtFilterModelExceptionItem >> ifSome: aBlock ifNone: aNoneBlock [
	"Exception item is not expected in any model.
	We therefore treat it as an item without a value.
	Widgets can treat it differently using #isExceptionFilterModelItem."

	^ aNoneBlock value
]

{ #category : #testing }
GtFilterModelExceptionItem >> isExceptionFilterModelItem [
	^ true
]

{ #category : #accessing }
GtFilterModelExceptionItem >> label [
	"Return item label or nil"

	<return: #String or: #BlText>
	^ self exception
		ifNotNil: [ :anException | anException printStringLimitedTo: 30 ]
		ifNil: [ 'exception' ]
]
