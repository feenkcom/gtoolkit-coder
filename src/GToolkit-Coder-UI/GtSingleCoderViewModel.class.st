"
1. Coder UI Model
Wraps {{gtClass:GtCoderModel}} and optionally adds UI related api and state. Coder UI Model should be passed to any Coder UI element instead of the {{gtClass:GtCoderModel}}


"
Class {
	#name : #GtSingleCoderViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'codersUIModel',
		'coderModel',
		'extraAddOns',
		'addOnPromise'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtSingleCoderViewModel class >> addOnsExecutionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #CoderAddOn;
		lowPriority
]

{ #category : #'api - shortcuts' }
GtSingleCoderViewModel >> addMainAction: aGtCoderAction [
	"Add an extra main action add-on independent from the dynamically computed add-ons"

	extraAddOns addMainAction: aGtCoderAction
]

{ #category : #'api - add-ons' }
GtSingleCoderViewModel >> addOns [
	<return: #TAsyncPromise>

	^ self ensureAddOns
]

{ #category : #accessing }
GtSingleCoderViewModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtSingleCoderViewModel >> announcerUIModel [
	^ self announcer
]

{ #category : #converting }
GtSingleCoderViewModel >> asCoderViewModel [
	^ self
]

{ #category : #converting }
GtSingleCoderViewModel >> asElement [
	^ self elementClass new
		coderViewModel: self;
		yourself
]

{ #category : #accessing }
GtSingleCoderViewModel >> coder [
	^ self coderModel
]

{ #category : #accessing }
GtSingleCoderViewModel >> coder: anObject [
	self coderModel: anObject
]

{ #category : #accessing }
GtSingleCoderViewModel >> coderLook [
	^ self coder coderLook
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> coderModel [
	"Return a not-null coder model assigned to the receiver view model"
	self
		assert: [ coderModel notNil ]
		description: [ 'coder model should be initialized' ].

	^ coderModel
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> coderModel: aCoderModel [
	"Set a not-null coder domain model assigned to the receiver view model"
	self
		assert: [ aCoderModel notNil ]
		description: [ 'coder model must not be nil' ].

	coderModel == aCoderModel 
		ifTrue: [ ^ self ].

	coderModel ifNotNil: [ self unsubscribeFromCoderModel ].
	coderModel := aCoderModel.

	self onCoderModelChanged.
	self subscribeToCoderModel
]

{ #category : #accessing }
GtSingleCoderViewModel >> coders [
	^ self coder coders
]

{ #category : #accessing }
GtSingleCoderViewModel >> codersUIModel [
	^ codersUIModel
]

{ #category : #accessing }
GtSingleCoderViewModel >> codersUIModel: anObject [
	codersUIModel := anObject
]

{ #category : #'private - addons' }
GtSingleCoderViewModel >> computeAddOns [
	self subclassResponsibility
]

{ #category : #accessing }
GtSingleCoderViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #'private - addons' }
GtSingleCoderViewModel >> ensureAddOns [
	<return: #TAsyncPromise>

	^ addOnPromise ifNil: [ 
		addOnPromise := self computeAddOns 
			then: [ :theAddOns | 
				self onAddOnsChanged: theAddOns ]
			otherwise: [ :anError |
				anError emit.
					
				NonInteractiveTranscript stderr
					nextPutAll: 'Error computing addons: ';
					space;
					print: anError;
					cr ];
			yourself ]
]

{ #category : #accessing }
GtSingleCoderViewModel >> evaluationResult [
	^ nil
]

{ #category : #'gt-extension' }
GtSingleCoderViewModel >> gtLiveFor: aView [
	<gtView>

	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self asElement ];
		view: #gtLiveFor:
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> hasCoder [
	"Return a true if coder model is assigned to the receiver, false otherwise"
	<return: #Boolean>

	^ coderModel notNil 
]

{ #category : #accessing }
GtSingleCoderViewModel >> hasFocus [

	self
		deprecated: 'Please use #focused instead'
		transformWith: '`@receiver hasFocus' -> '`@receiver focused'.

	^ self focused
]

{ #category : #accessing }
GtSingleCoderViewModel >> hasFocus: aBoolean [
	self
		deprecated: 'Please use #focused: instead.'
		transformWith:
			'`@receiver hasFocus: `@statements1'
				-> '`@receiver focused: `@statements1'.

	self focused: aBoolean
]

{ #category : #testing }
GtSingleCoderViewModel >> isModified [
	^ self coder isModified
]

{ #category : #'private - event handling' }
GtSingleCoderViewModel >> onAddOnsChanged: theAddOns [
	
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> onCoderModelChanged [
	"Is sent when a new coder model is assigned to the view model"
]

{ #category : #'api - add-ons' }
GtSingleCoderViewModel >> requestUpdateAddOns [
	<return: #TAsyncPromise>

	addOnPromise := nil.
	^ self ensureAddOns
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> subscribeToCoderModel [
	"Is sent after a new coder model is assigned to the view model.
	It is required to unsubscribe from the domain model by implementing
	#unsubscribeFromCoderModel if view model subscribes to them"
	
	self coderModel subscribeToSystem
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> unsubscribeFromCoderModel [
	"Is sent before a new coder model is assigned to the view model.
	View models that subscribe to coder model are required to implement this methods"
	
	"unsubscribing here is not good, what if there are multiple view models on the same coder model?"
	"self coderModel unsubscribeFromSystem"
]
