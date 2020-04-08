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
GtTraitDefinition class >> fromTrait: aTrait [
	^ self new fromTrait: aTrait
]

{ #category : #converting }
GtTraitDefinition >> asDefinitionString [
	<return: #String>
	| aStream |

	aStream := (String new: 800) writeStream.

	aStream nextPutAll: 'ProtoObject subclass: ';
			store: self name.

	"Traits"
	(self traits isEmpty) ifFalse: [
		aStream cr; tab; nextPutAll: 'uses: ';
			nextPutAll: self traits asDefinitionString ].		
	
	"Slots"
	aStream cr; tab; nextPutAll: 'slots: ';
			nextPutAll: self slots asDefinitionString.

	aStream cr; tab; nextPutAll: 'package: ';
			store: self category asDefinitionString.

	aStream nextPutAll: '.'; cr.
	aStream nextPutAll: self name.
	aStream space; nextPutAll: 'superclass: nil'.

	^ aStream contents
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

{ #category : #'api - accepting' }
GtTraitDefinition >> difference: aGtCodeDefinitionDiffrence toRefactoringsOf: aClass [
	^ aGtCodeDefinitionDiffrence asClassRefactorings: aClass
]

{ #category : #'api - accepting' }
GtTraitDefinition >> difference: aGtCodeDefinitionDiffrence toRefactoringsOf: aClass in: anRBModel [
	^ aGtCodeDefinitionDiffrence asClassRefactorings: aClass in: anRBModel
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
