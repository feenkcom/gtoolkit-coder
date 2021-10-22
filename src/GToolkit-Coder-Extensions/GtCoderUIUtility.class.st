Class {
	#name : #GtCoderUIUtility,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Extensions'
}

{ #category : #'instance creation' }
GtCoderUIUtility class >> newExamplesButtonForMethodsCoder: aMethodsCoder [

	^ BrButton new
		  addAptitude:
			  (GtFilterRunExampleButtonFourStateIconAptitude new coder:
					   aMethodsCoder);
		  addAptitude: BrGlamorousButtonWithIconAptitude
			  - BrGlamorousButtonWithLabelTooltipAptitude;
		  addAptitude:
			  (GtFilterRunExampleButtonTooltipAptitude new coder: aMethodsCoder);
		  icon: BrGlamorousVectorIcons play;
		  label: 'Run All Examples';
		  action: [ :element | 
			  aMethodsCoder exampler runExamplesFrom: element ]
]

{ #category : #'instance creation' }
GtCoderUIUtility class >> newTestSuiteButtonForMethodsCoder: aMethodsCoder [

	^ BrButton new
		  addAptitude: (GtPharoTestSuiteAptitude new coder: aMethodsCoder);
		  addAptitude: BrGlamorousButtonWithIconAptitude
			  - BrGlamorousButtonWithLabelTooltipAptitude;
		  addAptitude: (GtPharoStateTooltipAptitude new
				   coder: aMethodsCoder;
				   statesProvider: GtPharoTestCaseStateProvider new);
		  icon: BrGlamorousVectorIcons play;
		  label: 'Run Test Cases';
		  action: [ :element | 
		  aMethodsCoder testSuite playSelectedFrom: element ]
]
