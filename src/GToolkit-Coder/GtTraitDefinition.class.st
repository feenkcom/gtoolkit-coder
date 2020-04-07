Class {
	#name : #GtTraitDefinition,
	#superclass : #GtBehaviorDefinition,
	#instVars : [
		'slots',
		'traits',
		'category'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtTraitDefinition class >> fromTrait: aTrait [
	^ self new fromTrait: aTrait
]

{ #category : #'api - trait' }
GtTraitDefinition >> browseFrom: anEvent [
	self class environment
		at: self name
		ifPresent: [ :aTrait | anEvent currentTarget phlow spawnObject: aTrait ]
]

{ #category : #accessing }
GtTraitDefinition >> category [
	<return: #GtCategoryDefinition>

	^ category
]

{ #category : #'gt - editors' }
GtTraitDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionEditor>

	^ { 
		self category categoryEditor.
		self traits traitsEditor.
		self slots slotsEditor.
	}
]

{ #category : #initialization }
GtTraitDefinition >> fromTrait: aTrait [
	ringDefinition := aTrait asRingDefinition.
	originalName := aTrait name.
	
	category := (GtCategoryDefinition fromBehavior: aTrait) parent: self.

	slots := (GtSlotsDefinition fromTrait: aTrait) parent: self.
	traits := (GtTraitsDefinition fromTrait: aTrait) parent: self
]

{ #category : #'gt-extension' }
GtTraitDefinition >> gtSlotsFor: aView [
	<gtView>

	^ aView forward
		title: 'Slots';
		priority: 2;
		object: [ slots ];
		view: #gtSlotsFor:
]

{ #category : #'gt-extension' }
GtTraitDefinition >> gtTraitsFor: aView [
	<gtView>

	^ aView forward
		title: 'Traits';
		priority: 3;
		object: [ traits ];
		view: #gtTraitsFor:
]

{ #category : #accessing }
GtTraitDefinition >> slots [
	<return: #GtSlotsDefinition>

	^ slots
]

{ #category : #accessing }
GtTraitDefinition >> traits [
	<return: #GtTraitsDefinition>
	
	^ traits
]
