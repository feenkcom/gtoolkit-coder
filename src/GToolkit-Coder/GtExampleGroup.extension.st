Extension { #name : #GtExampleGroup }

{ #category : #'*GToolkit-Coder' }
GtExampleGroup >> gtExpandableExamplesFor: aView [
	<gtView>
	^ aView explicit
		title: 'Examples';
		priority: 1;
		stencil: [ | theExamples aMethodsCoder |
			theExamples := self examples.
			aMethodsCoder := GtExampleGroupCoder new.
			aMethodsCoder forExampleGroup: (theExamples collect: [ :each | each example ]).
			aMethodsCoder ];
		actionButtonIcon: BrGlamorousIcons playall 
			action: [ :aButton | self runAll ]
]
