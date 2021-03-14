Class {
	#name : #GtTextualCoderViewModel,
	#superclass : #GtCoderUIModel,
	#instVars : [
		'hasFocus',
		'expanded',
		'stylers',
		'addOns',
		'addOnMonitor',
		'addOnCommand',
		'addOnCommandBlock'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addOnsAsyncDo: aBlock [
	addOnMonitor critical: [
		addOnCommand ifNotNil: [
			"the add-ons are being computed, subscribe to the ast changed announcement to wait until is finishes"
			^ self
				when: GtCoderViewModelAddOnsChanged
				doOnce: [ :anAnnouncement |
					aBlock value: anAnnouncement addOns ]
				for: #addOnsChanged ].

		"the add-ons are already computed, return it directly"
		addOns ifNotNil: [ :theAddOns | ^ aBlock value: theAddOns ].

		addOnCommandBlock := [
			| theComputedAddOns |

			theComputedAddOns := self computeAddOns.
			addOnMonitor critical: [
				addOns := theComputedAddOns.
				addOnCommand := nil.
				addOnCommandBlock := nil.
				self announce: (GtCoderViewModelAddOnsChanged new addOns: theComputedAddOns) ].
			aBlock value: theComputedAddOns ].
		addOnCommand := addOnCommandBlock asBlTktTerminableCommand asBlTktLoggingCommand.

		BlUseAsyncFeatures 
			ifEnabledDo: [ BlTktWorkerProvider coderAddOnsPool schedule: addOnCommand ]
			otherwise: [ addOnCommand execute ] ]
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addOnsAwait [
	| theAddOns |
	
	theAddOns := nil.
	self addOnsAwaitDo: [ :theComputedAddOns | theAddOns := theComputedAddOns ].
	^ theAddOns
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addOnsAwaitDo: aBlock [
	| aSemaphore theAddOns |
	
	aSemaphore := Semaphore new.
	theAddOns := nil.
	self addOnsAsyncDo: [ :theComputedAddOns |
		theAddOns := theComputedAddOns.
		aSemaphore signal ].
	
	aSemaphore wait: 5 seconds.
	aBlock value: theAddOns
]

{ #category : #'private - addons' }
GtTextualCoderViewModel >> computeAddOns [
	| aCoderModel newAddOns pragmas theAst |
		
	aCoderModel := self coderModel.
	
	theAst := aCoderModel astAwait.
	pragmas := aCoderModel
		pragmasNamed: #gtAstCoderAddOns:
		inHierarchy: aCoderModel class.

	newAddOns := aCoderModel newAddOns.
	"theAst ifNotNil: [
		pragmas reverseDo: [ :each | aCoderModel perform: each methodSelector with: theAst with: newAddOns ] ]."

	^ newAddOns
]

{ #category : #initialization }
GtTextualCoderViewModel >> initialize [
	super initialize.
	
	addOnMonitor := Monitor new
]

{ #category : #'private - event handling' }
GtTextualCoderViewModel >> onAstChanged: anAstChangedAnnouncement [
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> onCoderModelChanged [
	super onCoderModelChanged.
	
	
]

{ #category : #'private - event handling' }
GtTextualCoderViewModel >> onSourceCodeChanged: anSourceCodeChangedAnnouncement [

	self coderModel 
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> subscribeToCoderModel [
	super subscribeToCoderModel.
	
	self coderModel weak
		when: GtCoderAstChanged
		send: #onAstChanged:
		to: self.
		
	self coderModel weak
		when: GtCoderSourceCodeChanged
		send: #onSourceCodeChanged:
		to: self
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> unsubscribeFromCoderModel [
	super unsubscribeFromCoderModel.
	
	self coderModel unsubscribe: self
]
