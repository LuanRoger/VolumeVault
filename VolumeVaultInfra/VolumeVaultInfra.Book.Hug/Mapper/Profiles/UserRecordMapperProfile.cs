using AutoMapper;
using FirebaseAdmin.Auth;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class UserRecordMapperProfile : Profile
{
    public UserRecordMapperProfile()
    {
        CreateMap<UserRecord, UserInfo>();
    }
}