Extension { #name : #Announcement }

{ #category : #'*GToolkit-Coder' }
Announcement class >> gtAllKindOfReferencesFor: aView [
	<gtClassView>
	
	^ aView forward
		title: 'Announcement references';
		tooltip: 'Class and subclass references';
		priority: 41;
		object: [ self gtReferencesWithSubclasses ];
		view: #gtItemsFor:;
		actionUpdateButtonTooltip: 'Update reference list'
]
