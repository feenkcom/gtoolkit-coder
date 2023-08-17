Extension { #name : #GtMagritteModelExamples }

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteModelExamples >> simpleBaselineDescription [

	<gtExample>
	^ MAPriorityContainer withAll: { (MAStringDescription new
			   accessor: (MADictionaryAccessor key: #baseline);
			   beAlwaysEditable;
			   blocCompletion: [ GtClassesCompletionStrategy new ];
			   beRequired;
			   addCondition: [ :aValue | aValue beginsWith: 'BaselineOf' ]
			   labelled: 'Baseline name must begin with BaselineOf';
			   addCondition: [ :aValue | 
				   (Smalltalk globals includesKey: aValue asSymbol) not ]
			   labelled: 'Baseline name must be a non-existent class';
			   comment: 'Baseline name') }
]
