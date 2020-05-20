Class {
	#name : #GtMetaclassDefinition,
	#superclass : #GtBehaviorDefinition,
	#instVars : [
		'slots',
		'category'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtMetaclassDefinition class >> fromMetaclass: aMetaclass [
	^ self new fromMetaclass: aMetaclass
]

{ #category : #converting }
GtMetaclassDefinition >> asDefinitionString [
	^ String streamContents: [:stream |
		stream print: self.
		stream
			crtab;
			nextPutAll: 'slots: ';
			store: self slots asDefinitionString ]
]

{ #category : #accessing }
GtMetaclassDefinition >> category [
	<return: #GtCategoryDefinition>

	^ category
]

{ #category : #'api - accepting' }
GtMetaclassDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aClass [
	^ aGtCodeDefinitionDifference asClassRefactorings: aClass
]

{ #category : #'api - accepting' }
GtMetaclassDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aClass in: anRBModel [
	^ aGtCodeDefinitionDifference asClassRefactorings: aClass in: anRBModel
]

{ #category : #'api - accepting' }
GtMetaclassDefinition >> differenceWith: aMetaclassDefinition [
	| aDifference |
	
	self
		assert: [ aMetaclassDefinition class = self class ]
		description: [ 'Must be of the same type' ].
	
	aDifference := GtMetaclassDefinitionDifference new.

	self name = aMetaclassDefinition name
		ifFalse: [ aDifference nameFrom: aMetaclassDefinition name to: self name ].

	aDifference add: (self slots differenceWith: aMetaclassDefinition slots).

	^ aDifference
]

{ #category : #'gt - viewers' }
GtMetaclassDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self category categoryEditor.
		self slots slotsEditor.
	}
]

{ #category : #initialization }
GtMetaclassDefinition >> fromMetaclass: aMetaclass [
	"Initialize me from a given real Metaclass"

	name := aMetaclass name.
	originalName := name.
	
	category := (GtCategoryDefinition fromBehavior: aMetaclass) parent: self.
	slots := (GtClassSlotsDefinition fromClass: aMetaclass) parent: self
]

{ #category : #'gt - viewers' }
GtMetaclassDefinition >> readers [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self category categoryReader.
	}
]

{ #category : #accessing }
GtMetaclassDefinition >> slots [
	<return: #GtSlotsDefinition>

	^ slots
]
