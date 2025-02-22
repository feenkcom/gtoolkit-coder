Extension { #name : #Announcement }

{ #category : #'*GToolkit-Coder' }
Announcement class >> gtAllKindOfReferencesFor: aView [
	<gtClassView>
	^ aView explicit
		title: 'Announcement references';
		tooltip: 'Class and subclass references';
		priority: 41;
		stencil: [ self gtReferencesWithSubclasses ];
		actionUpdateButtonTooltip: 'Update reference list'
]
