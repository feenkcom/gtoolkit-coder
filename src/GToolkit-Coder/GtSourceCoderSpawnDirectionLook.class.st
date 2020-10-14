Class {
	#name : #GtSourceCoderSpawnDirectionLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'switchButton'
	],
	#category : #'GToolkit-Coder-Direction'
}

{ #category : #initialization }
GtSourceCoderSpawnDirectionLook >> initialize [
	super initialize.

	switchButton := self newSwitchButton.

	self addChangeAddChildAs: #(content switchButton) with: [ switchButton ]
]

{ #category : #'instance creation' }
GtSourceCoderSpawnDirectionLook >> newSwitchButton [
	^ BrButton new 
		look: BrGlamorousButtonWithIconLook-BrGlamorousButtonExteriorLook;
		action: [ self switchSpawnDirection ];
		label: 'Change the place where inspected objects are shown.';
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ];
		zIndex: 10
]

{ #category : #hooks }
GtSourceCoderSpawnDirectionLook >> onCoderChanged: aCoder [
	self switchButton icon: aCoder spawnDirection icon
]

{ #category : #accessing }
GtSourceCoderSpawnDirectionLook >> switchButton [
	^ switchButton
]

{ #category : #'instance creation' }
GtSourceCoderSpawnDirectionLook >> switchSpawnDirection [
	self coder spawnDirection: self coder spawnDirection followingDirection.
	self switchButton icon: self coder spawnDirection icon
]
