Extension { #name : #GtExampleGroup }

{ #category : #'*GToolkit-Coder' }
GtExampleGroup >> gtExpandableExamplesFor: aView [
	<gtView>
	^ aView explicit
		title: 'Examples';
		priority: 1;
		stencil: [
			GtExampleGroupCoder new forExampleGroup: self examples ];
		actionButtonIcon: BrGlamorousIcons playall 
			action: [ :aButton | self runAll ]
]
