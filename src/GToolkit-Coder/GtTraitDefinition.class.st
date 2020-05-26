Class {
	#name : #GtTraitDefinition,
	#superclass : #GtBehaviorDefinition,
	#instVars : [
		'slots',
		'traits',
		'category'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtTraitDefinition class >> forNew [
	^ self new forNew
]

{ #category : #'instance creation' }
GtTraitDefinition class >> fromTrait: aTrait [
	^ self new fromTrait: aTrait
]

{ #category : #converting }
GtTraitDefinition >> asDefinitionString [
	<return: #String>
	| aStream |
	aStream := (String new: 800) writeStream.
	aStream
		nextPutAll: 'Trait named: ';
		store: self name.

	"Traits"
	aStream
		cr;
		tab;
		nextPutAll: 'uses: ';
		nextPutAll: self traits asDefinitionString.

	"Slots"
	aStream
		cr;
		tab;
		nextPutAll: 'slots: ';
		nextPutAll: self slots asDefinitionString.
	aStream
		cr;
		tab;
		nextPutAll: 'package: ';
		store: self category asDefinitionString.
	^ aStream contents
]

{ #category : #'api - trait' }
GtTraitDefinition >> browseFrom: anEvent [
	self class environment
		at: self name
		ifPresent: [ :aTrait | anEvent currentTarget phlow spawnTool: (GtClassCoderTool observedClass: aTrait) ]
]

{ #category : #accessing }
GtTraitDefinition >> category [
	<return: #GtCategoryDefinition>

	^ category
]

{ #category : #'api - accepting' }
GtTraitDefinition >> createBehaviorChange [
	^ RBAddTraitChange definition: self asDefinitionString
]

{ #category : #'api - accepting' }
GtTraitDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aClass [
	^ aGtCodeDefinitionDifference asClassRefactorings: aClass
]

{ #category : #'api - accepting' }
GtTraitDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aClass in: anRBModel [
	^ aGtCodeDefinitionDifference asClassRefactorings: aClass in: anRBModel
]

{ #category : #'api - accepting' }
GtTraitDefinition >> differenceWith: aTraitDefinition [
	| aDifference |
	
	self
		assert: [ aTraitDefinition class = self class ]
		description: [ 'Must be of the same type' ].
	
	aDifference := GtTraitDefinitionDifference new.

	self name = aTraitDefinition name
		ifFalse: [ aDifference nameFrom: aTraitDefinition name to: self name ].

	aDifference add: (self category differenceWith: aTraitDefinition category).
	aDifference add: (self slots differenceWith: aTraitDefinition slots).
	aDifference add: (self traits differenceWith: aTraitDefinition traits).

	^ aDifference
]

{ #category : #'gt - editors' }
GtTraitDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>

	^ { 
		self category categoryEditor.
		self traits traitsEditor.
		self slots slotsEditor.
	}
]

{ #category : #initialization }
GtTraitDefinition >> forNew [
	name := #TNameOfTrait.
	originalName := name.
	category := GtCategoryDefinition empty parent: self.
	slots := GtSlotsDefinition empty parent: self.
	traits := GtTraitsDefinition empty parent: self
]

{ #category : #initialization }
GtTraitDefinition >> fromTrait: aTrait [
	name := aTrait name.
	originalName := name.
	
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

{ #category : #'gt - editors' }
GtTraitDefinition >> readers [
	<return: #Collection of: #GtCodeDefinitionViewer>

	^ { 
		self category categoryReader.
	}
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
