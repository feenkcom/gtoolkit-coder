Class {
	#name : #GtCoderUIUtility,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Extensions'
}

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
