"
I am an ${class:BlElement}$.
I am an icon that represents an ${class:GtExampleWithResult}$ result state.
!! Not Executed State
${example:GtCoderExampleStateElementExamples>>#exampleStatusElement_NotExecuted|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
!! Success State
${example:GtCoderExampleStateElementExamples>>#exampleStatusElement_Success|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
!! Failure State
${example:GtCoderExampleStateElementExamples>>#exampleStatusElement_Failure|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
!! Error State
${example:GtCoderExampleStateElementExamples>>#exampleStatusElement_Error|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=50}$
"
Class {
	#name : #GtCoderExampleStateElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'example'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'private - asserting' }
GtCoderExampleStateElement >> assertExample: aGtExampleWithResult [
	self 
		assert: [ aGtExampleWithResult isNotNil ] 
		description: [ 'Example must be non-nil' ].
]

{ #category : #'api - accessing' }
GtCoderExampleStateElement >> example [
	<return: #GtExampleWithResult or: nil>
	^ example
]

{ #category : #'api - accessing' }
GtCoderExampleStateElement >> example: aGtExampleWithResult [
	self assertExample: aGtExampleWithResult.
	self unsubscribeFromExample.
	example := aGtExampleWithResult asExampleWithResult.
	self subscribeToExample.
	self onExampleChanged.
]

{ #category : #'private - accessing' }
GtCoderExampleStateElement >> exampleResult [
	<return: #GtExampleResult or: nil>
	^ self example ifNotNil: #result
]

{ #category : #initialization }
GtCoderExampleStateElement >> initialize [
	super initialize.
	self 
		geometry: BlCircle new;
		margin: (BlInsets all: 1);
		exact: 8@8
]

{ #category : #'private - hooks' }
GtCoderExampleStateElement >> onExampleChanged [
	self updateIcon.
]

{ #category : #'private - announcement handling' }
GtCoderExampleStateElement >> onExampleExecuted: aGtExampleExecuted [
	BlUseAsyncFeatures 
		ifEnabledDo: [  
			self enqueueTask: (BlTaskAction new action: [
				self updateIcon ]) ]
		otherwise: [ self updateIcon ]
]

{ #category : #'private - subscriptions' }
GtCoderExampleStateElement >> subscribeToExample [
	self example announcer weak
		when: GtExampleExecuted
		send: #onExampleExecuted:
		to: self.
]

{ #category : #'private - subscriptions' }
GtCoderExampleStateElement >> unsubscribeFromExample [
	self example ifNil: [ ^ self ].
	self example announcer unsubscribe: self.
]

{ #category : #'private - updating' }
GtCoderExampleStateElement >> updateIcon [
	| aState |
	aState := GtFilterExampleState default stateFromExample: self example.
	self background: aState color.
]
