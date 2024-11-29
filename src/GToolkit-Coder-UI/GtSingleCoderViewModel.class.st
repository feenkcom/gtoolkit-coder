"
1. Coder UI Model
Wraps {{gtClass:GtCoderModel}} and optionally adds UI related api and state. Coder UI Model should be passed to any Coder UI element instead of the {{gtClass:GtCoderModel}}

##Add-ons
Coders are extensible using a concept of an add-on. 
"
Class {
	#name : #GtSingleCoderViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtOptions',
	#classTraits : 'TGtAnnouncer classTrait + TGtOptions classTrait',
	#instVars : [
		'announcer',
		'codersUIModel',
		'coderModel',
		'extraAddOns',
		'addOnPromise',
		'currentAddOns',
		'addOnsCache'
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

	^ self addOnsFuture await: self class addOnsExecutionConfiguration
]

{ #category : #'api - add-ons' }
GtSingleCoderViewModel >> addOnsFuture [
	"Return a future that will be resolved to coder addons"
	<return: #TAsyncFuture>

	^ AsyncCachedFuture
		forFuture: self computeAddOnsFuture
		cache: addOnsCache
]

{ #category : #accessing }
GtSingleCoderViewModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtSingleCoderViewModel >> announcerUIModel [
	self
		deprecated: 'Use #announcer instead'
		transformWith: '`@receiver announcerUIModel' -> '`@receiver announcer'.

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

{ #category : #'private - addons' }
GtSingleCoderViewModel >> computeAddOnsFuture [
	<return: #TAsyncFuture>

	^ self subclassResponsibility
]

{ #category : #accessing }
GtSingleCoderViewModel >> elementClass [
	^ self subclassResponsibility
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

{ #category : #initialization }
GtSingleCoderViewModel >> initialize [
	super initialize.
	
	addOnsCache := AsyncFutureCache new
]

{ #category : #testing }
GtSingleCoderViewModel >> isModified [
	^ self coder isModified
]

{ #category : #'private - event handling' }
GtSingleCoderViewModel >> onAddOnsChanged: theAddOns [
	"Is sent by Coder Element from a UI thread when new add-ons are computed"

	currentAddOns := theAddOns
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> onCoderModelChanged [
	"Is sent when a new coder model is assigned to the view model"
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> onCoderRecomputeAddOnsRequest: aCoderAddOnsUpdateRequest [
	self requestUpdateAddOns
]

{ #category : #'api - add-ons' }
GtSingleCoderViewModel >> requestUpdateAddOns [
	addOnsCache resetCache.
	self announcer announce: (GtCoderViewModelRecomputeAddOnRequest new coderViewModel: self)
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> subscribeToCoderModel [
	"Is sent after a new coder model is assigned to the view model.
	It is required to unsubscribe from the domain model by implementing
	#unsubscribeFromCoderModel if view model subscribes to them"
	
	self coderModel subscribeToSystem.
	
	self coderModel announcer weak
		when: GtCoderAddOnsUpdateRequest
		send: #onCoderRecomputeAddOnsRequest:
		to: self
]

{ #category : #'api - coder model' }
GtSingleCoderViewModel >> unsubscribeFromCoderModel [
	"Is sent before a new coder model is assigned to the view model.
	View models that subscribe to coder model are required to implement this methods"
	
	self coderModel announcer unsubscribe: self
	
	"unsubscribing from system here is not good, what if there are multiple view models on the same coder model?"
	"self coderModel unsubscribeFromSystem"
]
