Class {
	#name : #GtCoderUIUtility,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Utilities'
}

{ #category : #'api - instance creation' }
GtCoderUIUtility class >> exampleExecutionToolbarFor: anExampleWithResult [

	^ BrToolbar new
		  aptitude: BrGlamorousToolbarAptitude new;
		  addItem: (BrButton new
				   aptitude: BrGlamorousButtonWithIconAptitude;
				   icon: BrGlamorousVectorIcons play;
				   label: 'Play';
				   action: [ :aButton | anExampleWithResult run ];
				   beTinySize);
		  addItem: (BrButton new
				   aptitude: BrGlamorousButtonWithIconAptitude;
				   icon: BrGlamorousVectorIcons playinspect;
				   label: 'Play and Inspect';
				   action: [ :aButton | 
					   anExampleWithResult run.
					   aButton phlow spawnObject: anExampleWithResult result ];
				   beTinySize);
		  addChild: (BrButton new
				   aptitude: BrGlamorousButtonWithIconAptitude;
				   icon: BrGlamorousVectorIcons debug;
				   label: 'Debug';
				   action: [ :aButton | 
					   anExampleWithResult openingDebugger result ];
				   beTinySize)
]
