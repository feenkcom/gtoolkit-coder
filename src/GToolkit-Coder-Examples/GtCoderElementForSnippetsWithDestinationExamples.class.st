"
I contain examples for working with destinations in a pharo code snippet.
"
Class {
	#name : #GtCoderElementForSnippetsWithDestinationExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - setup' }
GtCoderElementForSnippetsWithDestinationExamples >> coderContainerWithSpawnBelowHandler [
	"I contain an example of how the below event can be transformed."
	<gtExample>
	| coder coderElement containerElement | 
	coder := self snippetsCoderWithDestinationLook.
	coderElement := coder asElement.
	
	containerElement := BrFrame new
		hMatchParent;
		vFitContent.
	containerElement addChild: coderElement.
	
	coderElement
		when: GtPhlowObjectToSpawn
		do: [ :aSpawnEvent | 
			aSpawnEvent spawnDestination isSpawnBelow ifTrue: [ 
				aSpawnEvent consumed: true. 
				containerElement fireEvent: (GtPhlowObjectToSpawn new 
					previousSpawnEvent: aSpawnEvent;
					tool: aSpawnEvent tool; 
					sourceElement: aSpawnEvent currentTarget;
					spawnDestination: aSpawnEvent spawnDestination;
					yourself) ] ].
			
	^ containerElement
]

{ #category : #'examples ' }
GtCoderElementForSnippetsWithDestinationExamples >> coderContainerWithSpawnBelowHandler_InspectButtonClickOnSpawnBelowCoder [
	<gtExample>
	| aScripter spawnEvents |
	aScripter := self scripter.
	
	spawnEvents := OrderedCollection new.
	
	aScripter set 
		label: 'Initialize Coder Container';
		element: [ self coderContainerWithSpawnBelowHandler
			when: GtPhlowObjectToSpawn do: [ :anEvent |
				spawnEvents add: anEvent ];
			yourself ].
	aScripter click
		label: 'Click on destination button';
		onChildOfClass: GtExpandableSourceCoderElement;
		onGtPharoSnippetDestinationButton.
	aScripter click
		label: 'Click on the inspect button';
		onGtPharoSnippetInspectButton.
	aScripter wait forEmptySpaceTaskQueue.
	aScripter check
		label: 'Check spawn event';
		satisfies: [ 
			spawnEvents size = 1 and: [ 
				spawnEvents first spawnDestination isSpawnBelow and: [ 
					spawnEvents first previousSpawnEvent notNil and: [ 
						spawnEvents first previousSpawnEvent spawnDestination isSpawnBelow ] ] ] ].
	
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples ' }
GtCoderElementForSnippetsWithDestinationExamples >> coderElementScripter [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	
	aScripter substep: 'Initial check' do: [ :aStep |
		aStep set 
			label: 'Initialize Coder Element';
			element: [ self snippetsCoderWithDestinationLook asElement ].
		aStep wait forEmptySpaceTaskQueue.
		aStep check
			label: 'Check initial button icon';
			onGtPharoSnippetDestinationButton;
			value: [ :aButton | aButton icon asElement containerName ] equals: #'icon--right' ].
		
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples ' }
GtCoderElementForSnippetsWithDestinationExamples >> coderElementScripter_DestinationClick [
	<gtExample>
	| aScripter |
	aScripter := self coderElementScripter.
	aScripter
		substep: 'Change destination'
		do: [ :aStep | 
			aStep click
				label: 'Click on destination button';
				onGtPharoSnippetDestinationButton.
			aStep wait forEmptySpaceTaskQueue.
			aStep check
				label: 'Check changed button icon';
				onGtPharoSnippetDestinationButton;
				value: [ :aButton | aButton icon asElement containerName ] equals: #'icon--down'.
			aStep check
				label: 'Check coder destination';
				satisfies:
						[ :aCoderElement | aCoderElement coderUIModel coder spawnDestination isSpawnBelow ] ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples ' }
GtCoderElementForSnippetsWithDestinationExamples >> coderElementWithHandlerScripter_InspectButtonClickOnSpawnBelowCoder [
	<gtExample>
	| aScripter spawnEvents |
	aScripter := self scripter.
	
	spawnEvents := OrderedCollection new.
	
	aScripter set 
		label: 'Initialize Coder Element';
		element: [ self snippetsCoderWithDestinationLook asElement 
			when: GtPhlowObjectToSpawn do: [ :anEvent |
				spawnEvents add: anEvent ];
			yourself ].
	aScripter click
		label: 'Click on destination button';
		onGtPharoSnippetDestinationButton.
	aScripter click
		label: 'Click on the inspect button';
		onGtPharoSnippetInspectButton.
	aScripter wait forEmptySpaceTaskQueue.
	aScripter check
		label: 'Check spawn event';
		satisfies: [ 
			spawnEvents size = 1 and: [ 
				spawnEvents first spawnDestination isSpawnBelow and: [ 
					spawnEvents first previousSpawnEvent isNil ] ] ].
	
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples ' }
GtCoderElementForSnippetsWithDestinationExamples >> coderElementWithHandlerScripter_InspectButtonClickOnSpawnNextCoder [
	<gtExample>
	| aScripter spawnEvents |
	aScripter := self scripter.
	
	spawnEvents := OrderedCollection new.
	
	aScripter set 
		label: 'Initialize Coder Element';
		element: [ self snippetsCoderWithDestinationLook asElement 
			when: GtPhlowObjectToSpawn do: [ :anEvent |
				spawnEvents add: anEvent ];
			yourself ].
	aScripter click
		label: 'Click on destination button';
		onGtPharoSnippetInspectButton.
	aScripter wait forEmptySpaceTaskQueue.
	aScripter check
		label: 'Check spawn event';
		satisfies: [ 
			spawnEvents size = 1 and: [ 
				spawnEvents first spawnDestination isSpawnNextPane and: [ 
					spawnEvents first previousSpawnEvent isNil ] ] ].
	
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - setup' }
GtCoderElementForSnippetsWithDestinationExamples >> snippetsCoderWithDestinationLook [
	<gtExample>
	| coder |
	coder := GtPharoSnippetCoder new
		forSource: '1+1';
		coderLook: [ GtSourceCoderSpawnDestinationLook ].
	
	self assert: coder spawnDestination isSpawnNextPane.
	^ coder
]
