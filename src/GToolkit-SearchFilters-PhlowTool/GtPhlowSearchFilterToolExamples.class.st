"
I contain executable scripter examples for GtPhlowSearchFilterTool.
"
Class {
	#name : #GtPhlowSearchFilterToolExamples,
	#superclass : #Object,
	#category : #'GToolkit-SearchFilters-PhlowTool-Examples'
}

{ #category : #'examples - support' }
GtPhlowSearchFilterToolExamples >> createToolElementInScripter [
	<gtExample>
	<return: #BlScripter>
	| tool element scripter |
	tool := self phlowTool.
	element := tool asElement.
	scripter := BlScripter new
		model: tool;
		element: element;
		yourself.
	self assert: element class equals: GtPhlowSearchFilterToolElement.
	self assert: element searchFilter == tool searchFilter.
	^ scripter
]

{ #category : #'examples - inspector' }
GtPhlowSearchFilterToolExamples >> defaultObjectToolShowsSearchFilterTool [
	<gtExample>
	<return: #BlScripter>
	| filter tool scripter |
	filter := self searchFilter.
	tool := filter gtDefaultInspectorTool.
	scripter := BlScripter new
		model: tool;
		element: tool asTabElement;
		yourself.
	scripter phlowCompositeToolStep
		label: 'Default filter object tool contains the search filter tool';
		assertPhlowToolLabels: #('Search Filter' 'inspector')
			andTypes: { GtPhlowSearchFilterTool . GtInspectorTool };
		assertSelectedToolAtIndex: 1 withPhlowName: 'Search Filter';
		play.
	^ scripter
]

{ #category : #'examples - world' }
GtPhlowSearchFilterToolExamples >> pageToolWithSearchFilterSnippet [
	<gtExample>
	| page |
	page := LePage new
		addSnippet: (LePharoSnippet code: '''GToolkit-Examples-Dummies-Package'' gtPackageMatches');
		yourself.
	^ LePagePhlowTool new page: page
]

{ #category : #'examples - support' }
GtPhlowSearchFilterToolExamples >> phlowTool [
	<gtExample>
	| filter tool |
	filter := self searchFilter.
	tool := GtPhlowSearchFilterTool forSearchFilter: filter.
	self assert: tool searchFilter == filter.
	self assert: tool object == filter.
	self assert: tool name equals: 'Search Filter'.
	self assert: tool icon notNil.
	^ tool
]

{ #category : #'examples - support' }
GtPhlowSearchFilterToolExamples >> searchFilter [
	<gtExample>
	| filter |
	filter := 'GToolkit-Examples-Dummies-Package' gtPackageMatches.
	self assert: filter contents notEmpty.
	^ filter
]

{ #category : #'examples - standalone' }
GtPhlowSearchFilterToolExamples >> standaloneToolByClassViewShowsClasses [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self standaloneToolShowsViews.
	scripter multipleViewsToolStep
		label: 'Select the By Class view';
		clickOnTabWithName: 'By Class';
		assertSelectedTabWithName: 'By Class';
		play.
	scripter assertStep: [ :step |
		step
			label: 'Class view lists dummy example classes';
			// GtPhlowColumnedListId;
			value: [ :list | list items size ] equals: [ 15 ] ].
	^ scripter
]

{ #category : #'examples - standalone' }
GtPhlowSearchFilterToolExamples >> standaloneToolByMethodViewShowsMethods [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self standaloneToolShowsViews.
	scripter multipleViewsToolStep
		label: 'Select the By Method view';
		clickOnTabWithName: 'By Method';
		assertSelectedTabWithName: 'By Method';
		play.
	scripter assertStep: [ :step |
		step
			label: 'Method view lists dummy example methods';
			// GtPhlowColumnedListId;
			value: [ :list | list items size ] equals: [ 24 ] ].
	^ scripter
]

{ #category : #'examples - standalone' }
GtPhlowSearchFilterToolExamples >> standaloneToolByPackageViewShowsPackages [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self standaloneToolShowsViews.
	scripter multipleViewsToolStep
		label: 'Select the By Package view';
		clickOnTabWithName: 'By Package';
		assertSelectedTabWithName: 'By Package';
		play.
	scripter assertStep: [ :step |
		step
			label: 'Package view lists dummy example packages';
			// GtPhlowColumnedListId;
			value: [ :list | list items size ] equals: [ 7 ] ].
	scripter assertStep: [ :step |
		step
			label: 'First package is the first dummy package';
			// GtPhlowColumnedListId;
			// GtPhlowLabelWithIcon;
			@ 1;
			value: [ :label | label nameLabelText asString ] equals: [ 'GToolkit-Examples-Dummies-Package1' ] ].
	^ scripter
]

{ #category : #'examples - standalone' }
GtPhlowSearchFilterToolExamples >> standaloneToolCreationCodeViewShowsFilterCode [
	<gtExample>
	<return: #BlScripter>
	| filter |
	filter := self searchFilter.
	self assert: filter creationCodeString equals: '''GToolkit-Examples-Dummies-Package'' gtPackageMatches'.
	^ filter
]

{ #category : #'examples - standalone' }
GtPhlowSearchFilterToolExamples >> standaloneToolShowsHeader [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self createToolElementInScripter.
	scripter assertStep: [ :step |
		step
			label: 'Search filter tool header identifies the filter';
			id: #toolLabel;
			value: [ :label | label text asString ] equals: [ 'Search Filter' ] ].
	scripter assertStep: [ :step |
		step
			label: 'Search filter tool title describes the filter';
			id: #titleLabel;
			value: [ :label | label text asString ] equals: [ 'Filter: ''GToolkit-Examples-Dummies-Package'' packages matching' ] ].
	^ scripter
]

{ #category : #'examples - standalone' }
GtPhlowSearchFilterToolExamples >> standaloneToolShowsViews [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self createToolElementInScripter.
	scripter multipleViewsToolStep
		label: 'Search filter tool exposes its filter views';
		assertHasTabsWithNames: #('Results' 'By Package' 'By Class' 'By Method');
		assertSelectedTabWithName: 'Results';
		play.
	^ scripter
]

{ #category : #'examples - world' }
GtPhlowSearchFilterToolExamples >> worldTabWithInitialSnippetWithSearchFilter [
	<gtExample>
	<return: #BlScripter>
	| pageTool scripter |
	pageTool := self pageToolWithSearchFilterSnippet.
	scripter := BlScripter new.
	scripter
		extent: 1500 @ 800;
		element: GtWorldElement new;
		model: pageTool.
	scripter worldStep
		label: 'Open page in new tab';
		showInNewTabObject: pageTool;
		assertTabAtIndex: 2 hasLabel: 'Page';
		play.
	^ scripter
]

{ #category : #'examples - world' }
GtPhlowSearchFilterToolExamples >> worldTabWithPaneWithTool [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self worldTabWithInitialSnippetWithSearchFilter.

	scripter click
		label: 'Click on do it and inspect button';
		// GtSourceCoderDoItAndGoActionId;
		play.

	scripter worldStep
		label: 'World tab title is still Page after spawning a new pane';
		assertTabAtIndex: 2 hasLabel: 'Page';
		play.

	scripter phlowCompositeToolStep
		label: 'Second pane has the expected search filter tool';
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolTabsCount: 2;
		assertPhlowToolLabels: #('Search Filter' 'inspector')
			andTypes: { GtPhlowSearchFilterTool . GtInspectorTool };
		assertPhlowToolValueSatisfies: [ :aCompositeTool |
			aCompositeTool tools first searchFilter creationCodeString
				= '''GToolkit-Examples-Dummies-Package'' gtPackageMatches' ];
		assertSelectedToolAtIndex: 1 withTabName: 'Search Filter';
		play.

	^ scripter
]

{ #category : #'examples - world' }
GtPhlowSearchFilterToolExamples >> worldTabWithPaneWithTool_selectFilterResultView [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self worldTabWithPaneWithTool.
	
	scripter inspectorStep
		label: 'Check Results view is selected';
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Results';
		assertSelectedTabWithName: 'Results';
		play.
		
	scripter click
		label: 'Expand an editor in the Results view';
		onPagerPaneWithIndex: 2;
		// (GtSourceCoderId indexed: 1);
		// GtSourceCoderExpanderToggleId;
		play.
	scripter click
		label: 'Select editor in the Results view';
		onPagerPaneWithIndex: 2;
		// GtSourceCoderEditorInnerId;
		play.
		
	scripter worldStep
		label: 'World tab title changed after selecting a row in the raw view';
		assertTabAtIndex: 2 hasLabel: 'Filter: ''GTo...ages matching';
		play.
		
	^ scripter
]

{ #category : #'examples - world' }
GtPhlowSearchFilterToolExamples >> worldTabWithPaneWithTool_selectInspectorRawView [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self worldTabWithPaneWithTool.
	
	scripter phlowCompositeToolStep
		label: 'Select inspector tool';
		onPagerToolInPaneWithIndex: 2;
		clickOnToolAtIndex: 2;
		assertSelectedToolAtIndex: 2 withPhlowName: 'inspector';
		play.
		
	scripter worldStep
		label: 'After selecting the inspector tool the tab label is still Page';
		assertTabAtIndex: 2 hasLabel: 'Page';
		play.
		
	scripter inspectorStep
		label: 'Select the Raw view in the inspector tool';
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Raw';
		assertSelectedTabWithName: 'Raw';
		play.
		
	scripter click
		label: 'Select an element in the inspector raw view';
		onPagerPaneWithIndex: 2;
		// BrColumnedTree;
		// BrLabel;
		@ [ :aLabel | aLabel text asString = 'self' ];
		play.
		
	scripter worldStep
		label: 'World tab title changed after selecting a row in the raw view';
		assertTabAtIndex: 2 hasLabel: 'a GtSearchMe...ges matching)';
		play.
		
	^ scripter
]

{ #category : #'examples - world' }
GtPhlowSearchFilterToolExamples >> worldTabWithPaneWithTool_selectInspectorRawView_backToPage [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self worldTabWithPaneWithTool_selectInspectorRawView.
	
	scripter click
		label: 'Click editor in first pane';
		onPagerPaneWithIndex: 1;
		// GtSourceCoderEditorInnerId;
		play.
		
	scripter worldStep
		label: 'World tab title is Page again';
		assertTabAtIndex: 2 hasLabel: 'Page';
		play.
		
	^ scripter
]

{ #category : #'examples - world' }
GtPhlowSearchFilterToolExamples >> worldTabWithPaneWithTool_selectInspectorRawView_backToolView [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self worldTabWithPaneWithTool_selectInspectorRawView.
	
	scripter phlowCompositeToolStep
		label: 'Select filters tool';
		onPagerToolInPaneWithIndex: 2;
		clickOnToolAtIndex: 1;
		assertSelectedToolAtIndex: 1 withPhlowName: 'Search Filter';
		play.
		
	scripter worldStep
		label: 'After selecting the inspector tool the inspector label';
		assertTabAtIndex: 2 hasLabel: 'a GtSearchMe...ges matching)';
		play.
		
	scripter inspectorStep
		label: 'Check Results view is selected';
		onPagerPaneWithIndex: 2;
		assertSelectedTabWithName: 'Results';
		play.
		
	scripter click
		label: 'Expand an editor in the Results view';
		onPagerPaneWithIndex: 2;
		// (GtSourceCoderId indexed: 1);
		// GtSourceCoderExpanderToggleId;
		play.
	scripter click
		label: 'Select editor in the Results view';
		onPagerPaneWithIndex: 2;
		// GtSourceCoderEditorInnerId;
		play.
		
	scripter worldStep
		label: 'World tab title changed after selecting a row in the raw view';
		assertTabAtIndex: 2 hasLabel: 'Filter: ''GTo...ages matching';
		play.
		
	^ scripter
]
