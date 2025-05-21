program gatherv_pfunit_1
    use mpi
    implicit none

    ! Context type to mimic pFUnit
    type :: mpi_context
        integer :: root
        integer :: mpiCommunicator
    end type mpi_context

    type(mpi_context) :: this
    integer :: ierr, rank, size, i, j, total
    character(len=10), allocatable :: sendBuffer(:), recvBuffer(:)
    integer, allocatable :: counts(:), displacements(:)
    logical :: error
    integer :: numEntries

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Set up context
    this%root = 0
    this%mpiCommunicator = MPI_COMM_WORLD

    ! Each process sends 'rank + 1' strings of length 10
    numEntries = rank + 1
    allocate(sendBuffer(numEntries))
    do i = 1, numEntries
        write(sendBuffer(i), '(A,I0)') 'proc', rank  ! Dummy words: "proc0", "proc1", etc.
    end do

    ! Allocate receive buffers on root
    if (rank == this%root) then
        allocate(counts(size))
        allocate(displacements(size))
        total = 0
        do i = 0, size - 1
            counts(i+1) = (i + 1) * 10  ! Number of characters from each process
            displacements(i+1) = total
            total = total + counts(i+1)
        end do
        allocate(recvBuffer(total / 10))  ! Total number of strings
        recvBuffer = ''
    else
        allocate(counts(1), displacements(1), recvBuffer(1))  ! Dummy for non-root
    end if

    ! Perform MPI_Gatherv as in pFUnit
    call MPI_Gatherv(sendBuffer, numEntries * 10, MPI_CHARACTER, &
                     recvBuffer, counts, displacements, MPI_CHARACTER, &
                     this%root, this%mpiCommunicator, ierr)

    ! Verify results on root
    error = .false.
    if (rank == this%root) then
        total = 0
        do i = 0, size - 1
            do j = 1, i + 1
                if (trim(recvBuffer(total + j)) /= 'proc'//trim(adjustl(int2str(i)))) then
                    print *, "Error at rank ", i, " index ", j, &
                             ": expected 'proc", i, "', got '", &
                             trim(recvBuffer(total + j)), "'"
                    error = .true.
                end if
            end do
            total = total + i + 1
        end do
        if (.not. error) then
            print *, "MPI_Gatherv pFUnit test passed on root"
        end if
    end if

    ! Clean up
    deallocate(sendBuffer, recvBuffer, counts, displacements)
    call MPI_Finalize(ierr)

    if (error) stop 1

contains
    ! Helper function to convert integer to string
    function int2str(i) result(str)
        integer, intent(in) :: i
        character(len=10) :: str
        write(str, '(I0)') i
    end function int2str

end program gatherv_pfunit_1