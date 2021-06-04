"
I add to a coder a way to change the destination where inspected objects are shown. 

Each coder holds to its destination. Available destinations are modeled as subclasses of {{gtClass:GtPhlowSpawnDesiredDestination}}


"
Class {
	#name : #GtSourceCoderSpawnDestinationAptitude,
	#superclass : #GtSourceCoderAptitude,
	#instVars : [
		'switchButton'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #initialization }
GtSourceCoderSpawnDestinationAptitude >> initialize [
	super initialize.

	switchButton := self newSwitchButton.

	self addChangeAddChildAs: #(content switchButton) with: [ switchButton ]
]

{ #category : #'instance creation' }
GtSourceCoderSpawnDestinationAptitude >> newSwitchButton [
	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
		action: [ self switchSpawnDestination ];
		label: 'Change the place where inspected objects are shown.';
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ];
		zIndex: 10
]

{ #category : #hooks }
GtSourceCoderSpawnDestinationAptitude >> onCoderChanged: aGtSourceCoderUIModel [
	self switchButton 
		icon: aGtSourceCoderUIModel coder spawnDestination icon
]

{ #category : #accessing }
GtSourceCoderSpawnDestinationAptitude >> switchButton [
	^ switchButton
]

{ #category : #'instance creation' }
GtSourceCoderSpawnDestinationAptitude >> switchSpawnDestination [
	| aSourceCoder |
	
	aSourceCoder := self sourceCoderUIModel coder.
	aSourceCoder spawnDestination: aSourceCoder spawnDestination followingDestination.
	self switchButton icon: aSourceCoder spawnDestination icon
]
