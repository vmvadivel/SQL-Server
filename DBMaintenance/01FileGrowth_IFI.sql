/*
	SQL Server is waiting for Windows to provide storage space for a data/log file growth, or a DB restore.
	Check out IFI - Instant File Initialization.
	If IFI is enabled it would help DB restore and Data file growth activity to be faster. 
	Bcoz it doesn't need to wait till zeroing activity to complete and can use the allocated space immediately!
*/

 SELECT 
        r.start_time	AS TaskRunningSince,
        s.login_name,
        s.nt_user_name,
        s.[program_name],
        s.[host_name]
FROM 
	sys.dm_os_waiting_tasks t
	INNER JOIN	sys.dm_exec_connections c	ON t.session_id = c.session_id
	INNER JOIN	sys.dm_exec_requests r		ON t.session_id = r.session_id
	INNER JOIN	sys.dm_exec_sessions s		ON r.session_id = s.session_id
	CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) pl
WHERE 
	t.wait_type = 'PREEMPTIVE_OS_WRITEFILEGATHER' /* This wait type occurs when a file is being zero-initialized. Slow file growth */
