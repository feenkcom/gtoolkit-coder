Class {
	#name : #GtClassDefinition,
	#superclass : #GtBehaviorDefinition,
	#instVars : [
		'traits',
		'slots',
		'category'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtClassDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #'api - class vars' }
GtClassDefinition >> addClassVarNamed: aString [
	| aNewClassVariable |
	
	aNewClassVariable := ringDefinition addClassVarNamed: aString.
	self notifyClassVarAdded: aNewClassVariable
]

{ #category : #accessing }
GtClassDefinition >> category [
	<return: #GtCategoryDefinition>

	^ category
]

{ #category : #'api - class vars' }
GtClassDefinition >> classVarNames [
	<return: #Collection of: #String>

	^ ringDefinition classVarNames
]

{ #category : #'api - class vars' }
GtClassDefinition >> classVariables [
	^ ringDefinition classVariables
]

{ #category : #'gt - editors' }
GtClassDefinition >> classVariablesEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ GtCodeDefinitionPluralEditor new
			definition: self;
			title: 'Class vars';
			addSelector: #addClassVarNamed:;
			removeSelector: #removeClassVarNamed:;
			renameSelector: #renameClassVarNamed:to:;
			getSelector: #classVarNames;
			addEvent: GtBehaviorCoderHeaderClassVarAdded;
			removeEvent: GtBehaviorCoderHeaderClassVarRemoved;
			renameEvent: GtBehaviorCoderHeaderClassVarRenamed
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

	aDifference add: (self category differenceWith: aClassDefinition category).
	aDifference add: (self slots differenceWith: aClassDefinition slots).
	aDifference add: (self traits differenceWith: aClassDefinition traits).

	^ aDifference
]

{ #category : #'gt - editors' }
GtClassDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionEditor>
	
	^ { 
		self superclassEditor.
		self category categoryEditor.
	 	self traitsEditor.
		self slotsEditor.
		self classVariablesEditor
	}
]

{ #category : #initialization }
GtClassDefinition >> fromClass: aClass [
	"Initialize me from a given real Class"
	
	ringDefinition := aClass asRingDefinition.
	ringDefinition superclass: aClass superclass asRingDefinition.
	
	originalName := aClass name.

	category := GtCategoryDefinition fromBehavior: aClass.
	traits := (GtTraitsDefinition fromClass: aClass) parent: self.
	slots := (GtSlotsDefinition fromClass: aClass) parent: self
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

{ #category : #'private - notifying' }
GtClassDefinition >> notifyClassVarAdded: aClassVariable [
	self dispatchEvent: (GtBehaviorCoderHeaderClassVarAdded new classVariable: aClassVariable)
]

{ #category : #'private - notifying' }
GtClassDefinition >> notifyClassVarRemoved: aClassVariable [
	self dispatchEvent: (GtBehaviorCoderHeaderClassVarRemoved new classVariable: aClassVariable)
]

{ #category : #'private - notifying' }
GtClassDefinition >> notifyClassVarRenamed: aClassVariable from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorCoderHeaderClassVarRenamed new
		classVariable: aClassVariable;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #'api - class vars' }
GtClassDefinition >> removeClassVarNamed: aString [
	| aRemovedClassVariable |

	aRemovedClassVariable := ringDefinition classVarNamed: aString.
	ringDefinition removeClassVariable: aRemovedClassVariable.
	self notifyClassVarRemoved: aRemovedClassVariable
]

{ #category : #'api - class vars' }
GtClassDefinition >> renameClassVarNamed: aCurrentName to: aNewName [
	| aRenamedClassVariable |

	aRenamedClassVariable := ringDefinition classVarNamed: aCurrentName.
	aRenamedClassVariable name: aNewName.
	
	self
		notifyClassVarRenamed: aRenamedClassVariable
		from: aCurrentName
		to: aNewName
]

{ #category : #accessing }
GtClassDefinition >> slots [
	<return: #GtSlotsDefinition>

	^ slots
]

{ #category : #'gt - editors' }
GtClassDefinition >> slotsEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ GtCodeDefinitionPluralEditor new
		title: 'Slots';
		definition: self slots;
		addSelector: #addSlotNamed:;
		removeSelector: #removeSlotNamed:;
		renameSelector: #renameSlotNamed:to:;
		getSelector: #names;
		addEvent: GtBehaviorSlotAdded;
		removeEvent: GtBehaviorSlotRemoved;
		renameEvent: GtBehaviorSlotRenamed
]

{ #category : #'gt - editors' }
GtClassDefinition >> superclassEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ GtCodeDefinitionSingleEditor new
			definition: self;
			title: 'Superclass';
			getSelector: #theSuperclassName;
			completion: [ GtClassesCompletionStrategy forSuperclasses: ringDefinition realClass ]
]

{ #category : #'api - superclass' }
GtClassDefinition >> theSuperclass [
	<return: #RGBehavior>

	^ ringDefinition superclass
]

{ #category : #'api - superclass' }
GtClassDefinition >> theSuperclassName [
	<return: #String>

	^ ringDefinition superclass name
]

{ #category : #accessing }
GtClassDefinition >> traits [
	<return: #GtTraitsDefinition>
	
	^ traits
]

{ #category : #'gt - editors' }
GtClassDefinition >> traitsEditor [
	<return: #GtCodeDefinitionEditor>
	
	^ GtCodeDefinitionPluralEditor new
		definition: self traits;
		title: 'Traits';
		addSelector: #addTraitNamed:;
		removeSelector: #removeTraitNamed:;
		renameSelector: #renameTraitNamed:to:;
		getSelector: #names;
		addEvent: GtBehaviorTraitAdded;
		removeEvent: GtBehaviorTraitRemoved;
		renameEvent: GtBehaviorTraitRenamed;
		separator: [
			BrLabel new
				look: (BrGlamorousLabelLook new glamorousCodeFont foreground: BrGlamorousColors darkBorderColor );
				text: '+' ]
]
