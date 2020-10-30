Extension { #name : #GtSlotsDefinition }

{ #category : #'*GToolkit-Coder-Extensions' }
GtSlotsDefinition >> gtSlotsFor: aView [
	<gtView>
	
	self isEmpty
		ifTrue: [ ^ aView empty ].

	^ aView columnedList
		title: 'Slots';
		priority: 1;
		items: [ definitions ];
		column: 'Name' item: [ :eachSlot | eachSlot name ];
		column: 'Type' item: [ :eachSlot | eachSlot type ]
]
