Class {
	#name : #GtClassDefinition,
	#superclass : #GtBehaviorDefinition,
	#instVars : [
		'layout',
		'category',
		'slots',
		'classVariables',
		'traits',
		'pools',
		'superclass'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtClassDefinition class >> forNew [
	^ self new forNew
]

{ #category : #'instance creation' }
GtClassDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #converting }
GtClassDefinition >> asDefinitionString [
	<return: #String>
	| aStream |

	aStream := (String new: 800) writeStream.
	aStream nextPutAll: self superclass asDefinitionString.

	aStream nextPutAll: ' subclass: ';
			store: self name.

	(self traits isEmpty) ifFalse: [
		aStream cr; tab; nextPutAll: 'uses: ';
			nextPutAll: self traits asDefinitionString ].		
			
	(self layout layoutName = #FixedLayout) ifFalse: [
		aStream cr; tab; nextPutAll: 'layout: ';
			nextPutAll: self layout layoutName].
	
	"Slots"
	aStream cr; tab; nextPutAll: 'slots: ';
			nextPutAll: self slots asDefinitionString.
	
	"Class vars"
	aStream cr; tab; nextPutAll: 'classVariables: ';
			nextPutAll: self classVariables asDefinitionString.
	
	"Pool Dictionaries"
	aStream cr; tab; nextPutAll: 'poolDictionaries: ';
		store: self pools asDefinitionString.

	aStream cr; tab; nextPutAll: 'package: ';
			store: self category asDefinitionString.

	self superclass hasSuperclass ifFalse: [ 
		aStream nextPutAll: '.'; cr.
		aStream nextPutAll: self name.
		aStream space; nextPutAll: 'superclass: nil'. ].

	^ aStream contents
]

{ #category : #accessing }
GtClassDefinition >> category [
	<return: #GtCategoryDefinition>

	^ category
]

{ #category : #accessing }
GtClassDefinition >> classVariables [
	<return: #GtClassVariablesDefinition>

	^ classVariables
]

{ #category : #'api - accepting' }
GtClassDefinition >> createBehaviorChange [
	^ RBAddClassWithSlotsChange definition: self asDefinitionString
]

{ #category : #'api - accepting' }
GtClassDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aClass [
	^ aGtCodeDefinitionDifference asClassRefactorings: aClass
]

{ #category : #'api - accepting' }
GtClassDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aClass in: anRBModel [
	^ aGtCodeDefinitionDifference asClassRefactorings: aClass in: anRBModel
]

{ #category : #'api - accepting' }
GtClassDefinition >> differenceWith: aClassDefinition [
	| aDifference |
	
	self
		assert: [ aClassDefinition class = self class ]
		description: [ 'Must be of the same type' ].
	
	aDifference := GtClassDefinitionDifference new.

	self name = aClassDefinition name
		ifFalse: [ aDifference nameFrom: aClassDefinition name to: self name ].

	aDifference add: (self superclass differenceWith: aClassDefinition superclass).
	aDifference add: (self category differenceWith: aClassDefinition category).
	aDifference add: (self slots differenceWith: aClassDefinition slots).
	aDifference add: (self classVariables differenceWith: aClassDefinition classVariables).
	aDifference add: (self traits differenceWith: aClassDefinition traits).
	aDifference add: (self pools differenceWith: aClassDefinition pools).

	^ aDifference
]

{ #category : #'gt - viewers' }
GtClassDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self superclass superclassEditor.
		self category categoryEditor.
	 	self traits traitsEditor.
		self slots slotsEditor.
		self classVariables classVariablesEditor.
		self pools poolsEditor
	}
]

{ #category : #initialization }
GtClassDefinition >> forNew [
	| anEnvironment |
	name := #NameOfSubclass.
	originalName := name.
	
	anEnvironment := RGEnvironment new.
	anEnvironment backend: (RGReadOnlyImageBackend for: anEnvironment).
	
	layout := Object classLayout asRingMinimalDefinitionIn: anEnvironment.
	
	superclass := (GtClassSuperclassDefinition named: Object name) parent: self.
	category := GtCategoryDefinition empty parent: self.
	slots := GtSlotsDefinition empty parent: self.
	classVariables := GtClassVariablesDefinition empty parent: self.
	
	traits := GtTraitsDefinition empty parent: self.
	pools := GtPoolsDefinition empty parent: self
]

{ #category : #initialization }
GtClassDefinition >> fromClass: aClass [
	| anEnvironment |
	"Initialize me from a given real Class"
	
	name := aClass name.
	originalName := aClass name.
	
	anEnvironment := RGEnvironment new.
	anEnvironment backend: (RGReadOnlyImageBackend for: anEnvironment).
	
	layout := aClass classLayout asRingMinimalDefinitionIn: anEnvironment.
	
	superclass := (GtClassSuperclassDefinition fromClass: aClass) parent: self.
	category := (GtCategoryDefinition fromBehavior: aClass) parent: self.
	slots := (GtSlotsDefinition fromClass: aClass) parent: self.
	classVariables := (GtClassVariablesDefinition fromClass: aClass) parent: self.
	
	traits := (GtTraitsDefinition fromClass: aClass) parent: self.
	pools := (GtPoolsDefinition fromClass: aClass) parent: self
]

{ #category : #'gt-extension' }
GtClassDefinition >> gtSlotsFor: aView [
	<gtView>

	^ aView forward
		title: 'Slots';
		priority: 2;
		object: [ slots ];
		view: #gtSlotsFor:
]

{ #category : #'gt-extension' }
GtClassDefinition >> gtTraitsFor: aView [
	<gtView>

	^ aView forward
		title: 'Traits';
		priority: 3;
		object: [ traits ];
		view: #gtTraitsFor:
]

{ #category : #accessing }
GtClassDefinition >> layout [
	^ layout
]

{ #category : #accessing }
GtClassDefinition >> pools [
	<return: #GtPoolsDefinition>
	
	^ pools
]

{ #category : #'gt - viewers' }
GtClassDefinition >> readers [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self superclass superclassReader.
		self category categoryReader.
	}
]

{ #category : #accessing }
GtClassDefinition >> slots [
	<return: #GtSlotsDefinition>

	^ slots
]

{ #category : #accessing }
GtClassDefinition >> superclass [
	<return: #GtClassSuperclassDefinition>

	^ superclass
]

{ #category : #accessing }
GtClassDefinition >> traits [
	<return: #GtTraitsDefinition>
	
	^ traits
]
