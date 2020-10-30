Extension { #name : #GtTraitDefinition }

{ #category : #'*GToolkit-Coder-Extensions' }
GtTraitDefinition >> gtSlotsFor: aView [
	<gtView>

	^ aView forward
		title: 'Slots';
		priority: 2;
		object: [ slots ];
		view: #gtSlotsFor:
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtTraitDefinition >> gtTraitsFor: aView [
	<gtView>

	^ aView forward
		title: 'Traits';
		priority: 3;
		object: [ traits ];
		view: #gtTraitsFor:
]
