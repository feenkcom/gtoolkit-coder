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
		self traitsEditor.
		self slotsEditor.
	}
]

{ #category : #initialization }
GtTraitDefinition >> fromTrait: aTrait [
	ringDefinition := aTrait asRingDefinition.
	
	category := GtCategoryDefinition fromBehavior: aTrait.
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

{ #category : #'api - slots' }
GtTraitDefinition >> slots [
	<return: #GtSlotsDefinition>

	^ slots
]

{ #category : #'gt - editors' }
GtTraitDefinition >> slotsEditor [
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

{ #category : #'api - traits' }
GtTraitDefinition >> traits [
	<return: #GtTraitsDefinition>
	
	^ traits
]

{ #category : #'gt - editors' }
GtTraitDefinition >> traitsEditor [
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
