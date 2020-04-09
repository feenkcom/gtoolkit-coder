Extension { #name : #GtExampleGroup }

{ #category : #'*GToolkit-Coder' }
GtExampleGroup >> gtExpandableExamplesFor: aView [
	<gtView>
	^ aView explicit
		title: 'Examples';
		priority: 1;
		stencil: [
			GtExampleGroupCoder new forItems: self examples ];
		actionButtonIcon: BrGlamorousVectorIcons play 
			action: [ :aButton | self runAll ]
]
