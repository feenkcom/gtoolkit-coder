Extension { #name : 'Announcement' }

{ #category : '*GToolkit-Coder' }
Announcement class >> gtAllKindOfReferencesFor: aView [
	<gtClassView>
	^ aView explicit
		title: 'Announcement references';
		tooltip: 'Class and subclass references';
		priority: 41;
		stencil: [ 
			| aFilter |
			aFilter := self gtReferences.
			self allSubclassesDo: [ :eachClass | 
				aFilter := aFilter | eachClass gtReferences ].
			aFilter ];
		actionUpdateButtonTooltip: 'Update reference list'
]
