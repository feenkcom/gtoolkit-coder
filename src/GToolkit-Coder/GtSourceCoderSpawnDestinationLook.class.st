"
I add to a coder a way to change the destination where inspected objects are shown. 

Each coder holds to its destination. Available destinations are modeled as subclasses of ${class:GtPhlowSpawnDesiredDestination}$
"
Class {
	#name : #GtSourceCoderSpawnDestinationLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'switchButton'
	],
	#category : #'GToolkit-Coder-Direction'
}

{ #category : #initialization }
GtSourceCoderSpawnDestinationLook >> initialize [
	super initialize.

	switchButton := self newSwitchButton.

	self addChangeAddChildAs: #(content switchButton) with: [ switchButton ]
]

{ #category : #'instance creation' }
GtSourceCoderSpawnDestinationLook >> newSwitchButton [
	^ BrButton new 
		look: BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook;
		action: [ self switchSpawnDestination ];
		label: 'Change the place where inspected objects are shown.';
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ];
		zIndex: 10
]

{ #category : #hooks }
GtSourceCoderSpawnDestinationLook >> onCoderChanged: aCoder [
	self switchButton 
		icon: aCoder spawnDestination icon
]

{ #category : #accessing }
GtSourceCoderSpawnDestinationLook >> switchButton [
	^ switchButton
]

{ #category : #'instance creation' }
GtSourceCoderSpawnDestinationLook >> switchSpawnDestination [
	self coder 
		spawnDestination: self coder spawnDestination followingDestination.
	self switchButton icon: self coder spawnDestination icon
]
